class Communication::Block::Template
  class_attribute :fields

  attr_reader :block

  def self.has_string(property)
    has_field property, :string
  end

  def self.has_text(property)
    has_field property, :text
  end

  def self.has_rich_text(property)
    has_field property, :rich_text
  end

  def self.has_select(property, **args)
    has_field property, :select
  end

  def self.has_image(property)
    has_field property, :image
    has_field "#{property}_alt".to_sym, :string
    has_field "#{property}_credit".to_sym, :string
  end

  def self.has_field(property, kind)
    self.fields ||= []
    self.fields << { name: property, type: kind }
    sanitizers = {
      string: 'string',
      text: 'text',
      rich_text: 'text'
    }
    sanitizer_type = sanitizers[kind]
    class_eval <<-CODE, __FILE__, __LINE__ + 1
      def #{property}
        #{ kind == :image ? "extract_image_alt_and_credit(data, '#{property}')" : "data['#{property}']" }
      end

      def #{property}=(value)
        data['#{property}'] = #{ sanitizer_type ? "Osuny::Sanitizer.sanitize(value, '#{sanitizer_type}')" : "value" }
      end
    CODE
  end

  def initialize(block)
    @block = block
    @fields = []
  end

  def data=(value)
    json = JSON.parse value
    self.class.fields.each do |field|
      update_field field, json
    end
    true
  end

  def git_dependencies
    unless @git_dependencies
      @git_dependencies = []
      build_git_dependencies
      @git_dependencies.uniq!
    end
    @git_dependencies
  end

  def active_storage_blobs
    []
  end

  protected

  def update_field(field, json)
    name = field[:name]
    value = json["#{name}"]
    public_send "#{name}=", value
  end

  def build_git_dependencies
  end

  def add_dependency(dependency)
    if dependency.is_a? Array
      @git_dependencies += dependency
    else
      @git_dependencies += [dependency]
    end
  end

  def find_blob(object, key)
    id = object.dig(key, 'id')
    return if id.blank?
    university.active_storage_blobs.find id
  end

  def extract_image_alt_and_credit(source, variable)
    blob = find_blob source, variable
    return if blob.nil?
    alt = source["alt"] || source["#{variable}_alt"]
    credit = source["credit"] || source["#{variable}_credit"]
    text = source["text"] || source["#{variable}_text"]
    {
      blob: blob,
      alt: alt,
      credit: credit,
      text: text
    }.to_dot
  end

  def data
    block.data
  end

  def elements
    data.has_key?('elements') ? data['elements']
                              : []
  end

  def university
    block.university
  end
end

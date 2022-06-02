class Communication::Block::Component::Base
  attr_reader :property, :template

  def initialize(property, template)
    @property = property.to_s
    @template = template
    @data = nil
  end

  def data
    @data
  end

  def data=(value)
    @data = Osuny::Sanitizer.sanitize value, 'string'
  end
end

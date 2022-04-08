class Communication::Block::Template::Testimonial < Communication::Block::Template
  def build_git_dependencies
    add_dependency photos
  end

  def testimonials
    @testimonials ||= elements.map do |element|
      blob = find_blob element, 'photo'
      element['blob'] = blob
      element.to_dot
    end
  end

  protected

  def photos
    unless @photos
      @photos = []
      testimonials.each do |testimonial|
        @photos << testimonial.blob if testimonial.blob
      end
    end
    @photos
  end
end

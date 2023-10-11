class Video::Provider::Youtube < Video::Provider::Default
  DOMAINS = ['youtube.com', 'youtu.be']

  def identifier
    video_url.include?('youtu.be')  ? video_url.split('youtu.be/').last
                                    : video_url.split('v=').last
  end

  # https://img.youtube.com/vi/XEEUOiTgJL0/hqdefault.jpg
  def poster
    "https://img.youtube.com/vi/#{identifier}/hqdefault.jpg"
  end

  # https://developers.google.com/youtube/player_parameters
  def iframe_url
    "https://www.youtube.com/embed/#{identifier}"
  end
end

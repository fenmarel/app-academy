module PostsHelper
  def link_params
    params.permit(:links => {:url => []})
          .require(:links)
          .values.first
          .reject { |data| data.blank? }
          .map { |data| {:url => data} }
  end
end

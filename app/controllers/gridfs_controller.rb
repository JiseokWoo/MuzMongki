class GridfsController < ApplicationController
  def avatar
    @mongki = Mongki.find_by(_id: session[:id])
    content = @mongki.avatar.read
    if stale?(etag: content, last_modified: @mongki.updated_at.utc, public: true)
      send_data content, type: @mongki.avatar.file.content_type, disposition: "inline"
      expires_in 0, public: true
    end
  end
end

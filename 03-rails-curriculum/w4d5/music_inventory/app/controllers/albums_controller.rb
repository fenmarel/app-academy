class AlbumsController < ApplicationController
  before_action :set_album, :only => [:show, :destroy, :edit, :update]
  before_action :set_band, :only => [:new, :create, :index]

  def create
    @album = Album.new(album_params.merge(:band_id => params[:band_id]))

    if @album.save
      redirect_to band_url(@band)
    else
      flash.now[:errors] = @album.errors.full_messages
      render :new
    end
  end

  def destroy
    @album.destroy

    redirect_to band_url(@album.band)
  end

  def edit
    render :edit
  end

  def index
    @albums = @band.albums.includes(:tracks)

    render :index
  end

  def new
    @album = Album.new

    render :new
  end

  def show
    @band = @album.band

    render :show
  end

  def update
    if @album.update(album_params)
      redirect_to album_url(@album)
    else
      flash.now[:errors] = @album.errors.full_messages
      render :edit
    end
  end

  private

  def album_params
    params.require(:album).permit(:title, :album_type)
  end

  def set_band
    @band = Band.find(params[:band_id])
  end

  def set_album
    @album = Album.find(params[:id])
  end

end

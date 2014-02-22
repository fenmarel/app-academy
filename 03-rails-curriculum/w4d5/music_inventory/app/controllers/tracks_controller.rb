class TracksController < ApplicationController
  before_action :set_track, :only => [:show, :edit, :update, :destroy]

  def create
    @track = Track.new(all_track_params)

    if @track.save
      redirect_to track_url(@track)
    else
      flash.now[:errors] = @track.errors.full_messages
      render :new
    end
  end

  def destroy
    @track.destroy

    redirect_to album_url(@track.album)
  end

  def edit
    render :edit
  end

  def new
    @album = Album.find(params[:album_id])
    @track = Track.new

    render :new
  end

  def show
    render :show
  end

  def update
    if @track.update(track_params)
      redirect_to track_url(@track)
    else
      flash.now[:errors] = @track.errors.full_messages
      render :edit
    end
  end


  private

  def set_track
    @track = Track.find(params[:id])
  end

  def track_params
    params.require(:track).permit(:title, :track_number, :track_type, :lyrics)
  end

  def all_track_params
    track_params.merge(:album_id => params[:album_id])
  end
end

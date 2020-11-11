class CraftsController < ApplicationController
  before_action :set_craft, only: %i[edit update show destroy]

  def index
    @users = User.all
    @crafts = policy_scope(Craft)

    @markers = @crafts.geocoded.map do |craft|
      {
        lat: craft.latitude,
        lng: craft.longitude,
        infoWindow: render_to_string(partial: "info_window", locals: { craft: craft })
      }
    end
  end

  def show
    @craftman = User.find(@craft.user_id)
    @booking = Booking.new
    authorize @craft
  end

  def new
    @craft = Craft.new
    authorize @craft
  end

  def create
    @craft = Craft.create(craft_params)
    authorize @craft
    redirect_to crafts_path
  end

  def edit
    authorize @craft
  end

  def update
    @craft.update(params[:craft])
    authorize @craft
  end

  def destroy
    authorize @craft
    @craft.destroy
    redirect_to crafts_path
  end

  private

  def craft_params
    # Celui qui cree le craft c'est le current user
    params.require(:craft).permit(:description, :name, :price, :photo).merge(user: current_user)
  end

  def set_craft
    @craft = Craft.find(params[:id])
  end
end

class ContactsController < ApplicationController
  before_filter :set_contact, only: [:destroy, :show, :update]

  def create
    @contact = Contact.new(contact_params)

    if @contact.save
      render :json => @contact
    else
      render :json => @contact.errors.full_messages
    end
  end

  def destroy
    @contact.destroy

    render :json => @contact
  end

  def index
    @contacts = Contact.contacts_for_user_id(params[:user_id])

    render :json => @contacts
  end

  def show
    render :json => @contact
  end

  def update
    if @contact.update_attributes(contact_params)
      render :json => @contact
    else
      render :json => @contact.errors.full_messages
    end
  end

  def favorites
    @contacts = Contact.contacts_for_user_id(params[:user_id])
                       .where(favorite: true)

    render :json => @contacts
  end

  def toggle_fav
    @contact = Contact.find(params[:contact_id])
    @contact.toggle_fav

    if @contact.save
      render :json => @contact
    else
      render :json => @contact.errors.full_messages
    end
  end


  private

  def contact_params
    params.require(:contact).permit(:user_id, :name, :email)
  end

  def set_contact
    @contact = Contact.find(params[:id])
  end
end

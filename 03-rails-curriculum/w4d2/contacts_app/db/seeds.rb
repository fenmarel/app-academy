

u1 = User.create!(:username => 'Gizmo')
u2 = User.create!(:username => 'Ajax')

contact1 = Contact.create!(:name => "GIzmo", :email => "g@izmo.com", :user_id => 1)
contact2 = Contact.create!(:name => "Ajax", :email => "a@jax.com", :user_id => 2)

cs1 = ContactShare.create!(:user_id => 1, :contact_id => 2)
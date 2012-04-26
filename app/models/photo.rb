class Photo < ActiveRecord::Base
  belongs_to :imageable, :polymorphic => true, :counter_cache => true
end

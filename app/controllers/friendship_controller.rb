class FriendshipController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def index
    friendships = User.find(current_user.id).friendships
    user_ids = friendships.pluck(:friend_a_id, :friend_b_id).flatten
    user_ids.delete(current_user.id)
    friends = User.where(id: user_ids)
    render json: friends
  end

  def friendship
    friendship = Friendship.new
    friendship.friend_a_id = current_user.id
    friendship.friend_b_id = params[:userId]
    friend_request = FriendRequest
      .where('requestor_id = ? AND receiver_id = ?', params[:userId], current_user.id).first
    
    if friend_request.destroy!
      if friendship.save!
        render json: friendship
      else
        render status: 403, json: { error: 'Invalid friendship'}
      end
    end
  end


end

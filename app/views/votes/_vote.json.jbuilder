json.votable_type @votable.class.name.downcase
json.votable_id @votable.id
json.user_voted @votable.user_voted?(current_user)
json.is_like @votable.like_by?(current_user)
json.user_can_vote @votable.user_can_vote?(current_user)
json.total @votable.total
json.votable_path url_for(@votable)
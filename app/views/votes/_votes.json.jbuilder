json.votable_type @votable.class.name.downcase
json.votable_id @votable.id
json.like current_user.like?(@votable)
json.user_voted current_user.voted?(@votable)
json.user_can_vote !current_user.author_of?(@votable)
json.total @votable.total
json.votable_path url_for(@votable)

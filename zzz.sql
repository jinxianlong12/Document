select shift_users.domain_id, shift_users.creator_id, shift_users.updater_id, creator.id creator__id, creator.login creator__login,
creator.email creator__email, updater.id updater__id, updater.login updater__login, updater.email updater__email, shift_users.created_at,
shift_users.updated_at, shift_users.id, shift_users.shift_id, shift_users.user_id, user.id user__id, user.login user__login, user.email user__email
 from qdcrrcoes.shift_users
 left outer join qdcrrcoes.users creator on shift_users.creator_id = creator.id
 left outer join qdcrrcoes.users updater on shift_users.updater_id = updater.id
 left outer join qdcrrcoes.users user on shift_users.user_id = user.id
 where shift_users.id = ?];

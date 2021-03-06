//Handles server news
#define NEWSFILE "data/news.sav"	//where the memos are saved

/client/
	var/last_news_hash = null // Stores a hash of the last news window it saw, which gets compared to the current one to see if it is different.

// Returns true if news was updated since last seen.
/client/proc/check_for_new_server_news()
	var/savefile/F = get_server_news()
	if(F && md5(F["body"]) != last_news_hash)
		return TRUE
	return FALSE

/client/proc/modify_server_news()
	set name = "Modify Public News"
	set category = "Server"

	if(!check_rights(R_SERVER))
		return

	var/savefile/F = new(NEWSFILE)
	if(F)
		var/title = F["title"]
		var/body = F["body"]
		var/new_title = copytext(sanitize(input(src,"Write a good title for the news update.  Note: HTML is NOT supported.","Write News", title) as null|text),1,MAX_MESSAGE_LEN)
		var/new_body = copytext(sanitize(input(src,"Write the body of the news update here. Note: HTML is NOT supported.","Write News", body) as null|message),1,MAX_MESSAGE_LEN)
		F["title"] << new_title
		F["body"] << new_body
		F["author"] << key
		F["timestamp"] << time2text(world.realtime, "DDD, MMM DD YYYY")
		message_admins("[key] modified the news to read:<br>[new_title]<br>[new_body]")

/proc/get_server_news()
	var/savefile/F = new(NEWSFILE)
	if(F)
		return F

#undef NEWSFILE

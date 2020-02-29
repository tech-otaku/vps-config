USE tech_otaku;
UPDATE faze_usermeta SET meta_value='enabled' WHERE user_id=2 AND meta_key='googleauthenticator_enabled';
SELECT user_id, meta_key, meta_value FROM faze_usermeta WHERE user_id=2 AND meta_key='googleauthenticator_enabled';

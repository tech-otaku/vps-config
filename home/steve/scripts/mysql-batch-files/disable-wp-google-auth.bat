USE tech_otaku;
UPDATE faze_usermeta SET meta_value = "disabled" WHERE meta_key = "googleauthenticator_enabled";
SELECT meta_value FROM faze_usermeta WHERE meta_key = "googleauthenticator_enabled";

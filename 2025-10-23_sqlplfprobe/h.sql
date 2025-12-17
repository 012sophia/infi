select displayname, id from persons where (sex ='male' and displayname like 'Frau%') or (sex 
='female' and displayname like 'Herr%');
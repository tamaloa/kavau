INSTALL.md

required:
* ruby (see .ruby-version for which version)
* postgres Database

database config kopieren & anpassen
    cp config/database.yml.example config/database.yml

Neue credentials erstellen (falls kein config/master.key nicht vorhanden ist)
rm config/credentials.yml.enc
EDITOR=vim rails credentials:edit
token_key: "ein-guter-geheimer-schlüssel-kann-mit: 'rails secret' generiert werden"
hinzufügen

rails db:setup

rails server

=> http://localhost:3000
should be running app.
Login with
Login: admin
Passwort: Bitte-sofort-ändern!

Unter
http://localhost:3000/users
für den admin User anschließend Name, Vorname, Email, Passwort etc. ändern

Dann unter "Übersicht" neben Adresse auf das + Zeichen klicken um die Haus GmbH (mit Adresse) anzulegen.
Und anschließend für diese die weiteren Angaben (GF, Sitz, Konto etc.)
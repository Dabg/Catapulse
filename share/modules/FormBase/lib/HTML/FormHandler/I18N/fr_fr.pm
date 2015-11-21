package HTML::FormHandler::I18N::fr_fr;
# ABSTRACT: French message translations

use strict;
use warnings;
use base 'HTML::FormHandler::I18N';

use utf8;

# # Auto define lexicon
# our %Lexicon = (
#     '_AUTO' => 1,

#     # H::F::Field
#     'field is invalid' => 'Feld ist ungültig',
#     'Wrong value' => 'Ungültiger Wert',
#     '[_1] does not match' => '[_1] ist kein gültiger Wert',
#     '[_1] not allowed' => '[_1] ist nicht erlaubt',
#     '[_1] field is required' => 'Feld ist erforderlich',
#     'error occurred' => 'Fehler aufgetreten',
#     'Value must be between [_1] and [_2]' => 'Wert muss zwischen [_1] und [_2] liegen',
#     'Value must be greater than or equal to [_1]' => 'Wert muss größer oder gleich [_1] sein',
#     'Value must be less than or equal to [_1]' => 'Wert muss kleiner oder gleich [_1] sein',

#     # H::F::Types
#     'Must be a positive number' => 'Muss eine positive Zahl sein',
#     'Must be a positive integer' => 'Muss eine positive ganze Zahl sein',
#     'Must be a negative number'  => 'Muss eine negative Zahl sein',
#     'Must be a negative integer' => 'Muss eine negative ganze Zahl sein',
#     'Must be a single digit' => 'Muss eine einzelne Ziffer sein',
#     'Must be a non-empty single line of no more than 255 chars' => 'Muss eine nicht leere Zeile (max. 255 Zeichen) sein',
#     'Must be made up of letters, digits, and underscores' => 'Darf nur Buchstaben, Ziffern oder "_" enthalten',
#     'Not a valid IP address' => 'IP Adresse ungültig',
#     'Must not be all digits' => 'Darf nicht nur Ziffern enthalten',
#     'Not a valid state' => 'Kein gültiger Bundesstaat',
#     'Field contains non-printable characters' => 'Feld enthält nicht druckbare Zeichen',
#     'Must be between 4 and 255 chars' => '4 bis 255 Zeichen erforderlich',
#     'Zip is not valid' => 'PLZ ungültig',
#     'Must be a single line of no more than 255 chars' => 'Muss eine einzelne Zeile (max. 255 Zeichen) sein',
#     'Email is not valid' => 'E-Mail ist nicht gültig',
#     'Must not contain spaces' => 'Darf keine Leerzeichen enthalten',
#     'Field must contain a single word' => 'Feld muss ein einzelnes Wort enthalten',
#     'Must not be empty' => 'Feld darf nicht leer bleiben',
#     'Must be between 8 and 255 chars, and contain a non-alpha char' => 'Wert muss 8 bis 255 Zeichen und ein nicht alpha-num Zeichen enthalten',


#     # H::F::Field::Date
#     'Date is too early' => 'Datum ist zu früh',
#     'Date is too late'  => 'Datum ist zu spät',

#     # H::F::Field::DateTime
#     'Not a valid DateTime' => 'Ungültige Datums-/Zeitangabe',

#     # H::F::Field::Duration
#     'Invalid value for [_1]: [_2]' => 'Ungültiger Wert für [_1]: [_2]',

#     # H::F::Field::Email
#     'Email should be of the format [_1]' => 'E-Mail sollte die Form [_1] haben',

#     # H::F::Field::Integer
#     'Value must be an integer' => 'Muss eine positive ganze Zahl sein',

#     # H::F::Field::Money
#     'Value cannot be converted to money' => 'Wert kann nicht in Betrag konvertiert werden',
#     'Value must be a real number' => 'Muss eine Dezimalzahl sein',

#     # H::F::Field::Password
#     'Please enter a password in this field' => 'Bitte ein Passwort eingeben',
#     'Password must not match [_1]' => 'Passwort darf nicht mit \'[_1]\' übereinstimmen',

#     # H::F::Field::PasswordConf
#     'Please enter a password confirmation' => 'Bitte das Passwort bestätigen',
#     'The password confirmation does not match the password' => 'Passwort Bestätigung stimmt nicht überein',

#     # H::F::Field::PosInteger
#     'Value must be a positive integer' => 'Muss eine positive ganze Zahl sein',

#     # H::F::Field::Select
#     'This field does not take multiple values' => 'Mehrfachauswahl nicht erlaubt',
#     '\'[_1]\' is not a valid value' => '\'[_1]\' ist kein gültiger Wert',

#     # H::F::Field::Text
#     'Field should not exceed [quant,_1,character]. You entered [_2]' => 'Bitte auf [_1] Zeichen beschränken. Sie haben [_2] eingegeben',
#     'Field must be at least [quant,_1,character]. You entered [_2]' => 'Eingabe muss mindestens [_1] Zeichen lang sein. Sie haben nur [_2] eingegeben',

#     # H::F::Field::Upload
#     'File uploaded is empty' => 'Hochgeladene Datei ist leer',
#     'File is too small (< [_1] bytes)' => 'Datei ist zu klein (< [_1] bytes)',
#     'File is too big (> [_1] bytes)' => 'Datei ist zu groß (> [_1] bytes)',
#     'File not found for upload field' => 'Datei für upload Feld nicht gefunden',

#     # H::F::Model
#     'Value must be unique in the database' => 'Wert existiert bereits in der Datenbank',

#   );

# Auto define lexicon
our %Lexicon = (
    '_AUTO' => 1,

    # H::F::Field
    'field is invalid' => 'Chanmp invalide',
    'Wrong value' => 'Mauvaise valeur',
    '[_1] does not match' => '[_1] ne correspond pas',
    '[_1] not allowed' => '[_1] non autorisé',
    '[_1] field is required' => 'Le champ [_1] est requis',
    'error occurred' => 'Une erreur est survenue',
    'Value must be between [_1] and [_2]' => 'La valeur doit être comprise entre [_1] et [_2]',
    'Value must be greater than or equal to [_1]' => 'La valeur doit être supérieure ou égale à [_1]',
    'Value must be less than or equal to [_1]' => 'La valeur doit être supérieure ou égale à [_1]',

    # H::F::Types
    'Must be a positive number' => 'Doit être un nombre positif',
    'Must be a positive integer' => 'Doit être un nombre entier positif',
    'Must be a negative number'  => 'Doit être un nombre négatif',
    'Must be a negative integer' => 'Doit être un nombre entier négatif',
    'Must be a single digit' => 'Doit avoit un seul chiffre',
    'Must be a non-empty single line of no more than 255 chars' => 'Doit être une ligne non-vide avec au plus 255 caractères',
    'Must be made up of letters, digits, and underscores' => 'Doit être composé de lettres, chiffres et underscore (_))',
    'Not a valid IP address' => 'Adresse IP invalide',
    'Must not be all digits' => 'Ne doit pas être tous des chiffres',
    'Not a valid state' => 'Pas un état ​​valide',
    'Field contains non-printable characters' => 'Le champ contient des caractères non imprimables',
    'Must be between 4 and 255 chars' => 'Doit être compris entre 4 et 255 caractères',
    'Zip is not valid' => "Zip n'est pas valide",
    'Must be a single line of no more than 255 chars' => 'Doit être une simple ligne avec 255 caractères maximum',
    'Email is not valid' => "L'adresse mail n'est pas valide",
    'Must not contain spaces' => "Ne doit pas contenir d'espace",
    'Field must contain a single word' => 'Doit contenir un unique mot',
    'Must not be empty' => 'Ne doit âs être vide',
    'Must be between 8 and 255 chars, and contain a non-alpha char' => 'Doit être compris entre 8 et 255 charactères, et contenir un charactère non alpha numérique',


    # H::F::Field::Date
    'Date is too early' => 'La date est trop récente',
    'Date is too late'  => 'La date est trop tardive',

    # H::F::Field::DateTime
    'Not a valid DateTime' => 'DateTime invalide',

    # H::F::Field::Duration
    'Invalid value for [_1]: [_2]' => 'Valeur invalide pour [_1]: [_2]',

    # H::F::Field::Email
    'Email should be of the format [_1]' => "L'adresse mail doit être au format [_1]",

    # H::F::Field::Integer
    'Value must be an integer' => 'La valeur doit être un entier',

    # H::F::Field::Money
    'Value cannot be converted to money' => 'Ne peut être converti en monnaie',
    'Value must be a real number' => 'La valeur doit être un nombre réèl',

    # H::F::Field::PasswordConf
    'Please enter a password confirmation' => "Merci d'entrer un mot de passe de confirmation",
    'The password confirmation does not match the password' => "Le mot de passe de confirmation n'est pas égal au mot de passe",

    # H::F::Field::PosInteger
    'Value must be a positive integer' => 'La valeur doit être un entier positif',

    # H::F::Field::Select
    'This field does not take multiple values' => 'Ce champ ne prend pas de valeurs multiples',
    '\'[_1]\' is not a valid value' => '\'[_1]\' n\'est pas une valeur valide',

    # H::F::Field::Text
    'Field should not exceed [quant,_1,character]. You entered [_2]' => 'Le champ ne doit pas dépasser [quant,_1,character]. Vous avez entré [_2]',
    'Field must be at least [quant,_1,character]. You entered [_2]' => 'Le champ doit être d\'au moins [quant,_1,character]. Vous avez entré [_2]',

    # H::F::Field::Upload
    'File uploaded is empty' => 'Le fichier tléchargé est vide',
    'File is too small (< [_1] bytes)' => 'Fichier trop petit (< [_1] bytes)',
    'File is too big (> [_1] bytes)' => 'Fichier trop gros (> [_1] bytes)',
    'File not found for upload field' => 'Fichier non trouvé pour télécharger',

    # H::F::Model
    'Value must be unique in the database' => 'La valeur doit être unique en base de donnée',

     # H:F::Widget::Theme::Bootstrap
    'There were errors in your form' => 'Il y a des erreurs dans votre formulaire',
    'Create' => 'Créer',
    'Update' => 'Mettre à jour',
);

1;

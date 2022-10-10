#Variables
:local DeviceName [/system identity get name];
:local Date [/system clock get date];
:local dia [ :pick $Date 4 6 ];
:local mes [ :pick $Date 0 3 ];
:local year [ :pick $Date 7 11 ];
:local time [/system clock get time];
:local hour [:pick $time 0 2];
:local minuts [:pick $time 3 5];
:local backupconf "$DeviceName_$dia_$mes_$year_[$hour]H_[$minuts]M.backup";
:local backupconfig "$DeviceName-$dia_$mes_$year_[$hour]H_[$minuts]M_config.rsc";
:local SendTo "MAIL_USER";
:local Subject "BACKUP: $DeviceName [$Date]";
:local MessageText "$DeviceName - device backup-config file ";
:local Password "PASSWDBKP";
:local SendFrom "MAIL_USER";
:local PasswordMail "PASSWD";
:local SmtpServer [:resolve "smtp.server.com"];
:local UserName "MAIL_USER";
:local SmtpPort 587;
:local UseTLS "yes";
:delay 2s
#SettingSMTP
/tool e-mail
set address=$SmtpServer
set port=$SmtpPort
set from=$SendFrom
set user=$SendFrom
set password=$PasswordMail
:delay 2s
# Main script code
/system backup save name=$backupconf password=$Password
:delay 2s
/export file=$backupconfig
:delay 2s
:local files {$backupconf;$backupconfig};
:delay 2s
/tool e-mail send to=$SendTo subject=$Subject tls=starttls body=$MessageText file=$files
# Removing files
:delay 2s
/file remove $backupconf
:delay 2s
/file remove $backupconfig
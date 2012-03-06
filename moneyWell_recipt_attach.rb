#!/opt/local/bin/ruby

require 'rubygems' 
require 'sqlite3'
require 'date'
require 'find'
#require 'appscript'
#include Appscript

# get location of moneywell file
moneyWelldB = "/Users/lyle/Documents/banking.moneywell"

# get location of directory to check in
reciptDirectory = "/Users/lyle/Documents/Personal/Finacial/Recipts/2009/2009-05 May/"

# confirm money well is not running
db = SQLite3::Database.new( moneyWelldB )
rows = db.execute( "select Z_PK, ZAMOUNT, datetime(ZDATE,'unixepoch','31 years'), ZPAYEE, ZRECEIPTFILENAME, ZACCOUNT, ZPAYEE from ZTRANSACTION" )

print "Your moneyWell Database has #{rows.length} entries.\n"

def displayRecord(entry)
  # in case we want to give some information about a record
  pk, amount, date, payee, receipt, account, payee = entry
  dadate = Time.parse(date)
  return "
    Account: #{account}
    Payee  : #{payee}
    Date   : #{dadate.strftime('%Y-%m-%d')}
    Amount : #{amount}
    Receipt: #{receipt}" + "\n"
end




# step through the database records and change the files associated to a lable
rows.each do |entry|
  pk, amount, date, payee, receipt, account, payee = entry
  dadate = Time.parse(date)
  next if ! receipt
  #change the following path to specify where your recipts should show be. That way you 
  # will see a warning if your receipt file is astray 
  if receipt =~ /^\/Users\/lyle\/Documents\/Personal\/Finacial\/Recipts\/2009\/.*/ then
    # if the receipt is in the correct base location let's change it's file label
    # print displayRecord(entry)
    
    print "."
    `osascript -e 'tell application "Finder"' -e 'set daFile to "#{receipt}" as POSIX file as alias' -e 'set the label index of daFile to 6' -e 'end tell'`
    
    #exit
  else
    # if the receipt is in the wrong location we get a little warning letting us know they we might want to pudate the record and such.
    `osascript -e 'tell application "Finder"' -e 'set daFile to "#{receipt}" as POSIX file as alias' -e 'set the label index of daFile to 2' -e 'end tell'`
    print "\nWARNING this entry is in the wrong place:" + displayRecord(entry)
  end
end



exit

# 
if ! receipt then
  print "no receipt\n"
end


=begin

This is all commented out and does different things.
At one point I thought I would step through directories and see if the files
in the directory mached to a record in the database... but I don't currently
like the idea of updating moneywell's datebase without the applicationd doing it


# step though the directory finding files and getting their dates out
  d1 = Date.new(y=2008,m=3,d=22)
  puts d1
  Find.find(reciptDirectory) do |path|
    if FileTest.directory?(path)
      next
    else
      if (path =~ /.*Receipt\-(.*) (\d+) \$(\d+\.\d+)\.pdf/) then
        imagePayee = $1.to_s
        imageDate = $2.to_s
        imageAmount = $3.to_f
        print path + "\n"
        print "payee: #{imagePayee}" + "\n"
        print "date: #{imageDate}" + "\n"
        print "amount: #{imageAmount}" + "\n"
        if imageAmount == 19.14 then
          print "yep\n\n"
          #app("Finder").
        end
      end
    end
  end

  `osascript -e 'tell application "Finder"' -e 'set daFile to "/Users/lyle/Documents/Personal/Finacial/Recipts/2009/2009-05 May/Receipt-Kragen 05092009 $19.14.pdf" as POSIX file as alias' -e 'set the label index of daFile to 0' -e 'end tell'`
  # label color : 2=red, 0=none, 7=grey


  # logic for determining a match: is there an entry with no recipt that...
  # matches the date, payee, and amount?
  # link the recipt and modify the file color

  # matches the date and amount?
  # Move Money Wells Payee to the Notes field and use this recipt's payee for the money well payee field
  # link the recipt and modify the file color

  # matches the amount and the payee name and the date is within 5 days after the recipt date?
  # Put the recipt date in the notes field
  # link the recipt and modify the file color

  # matches the amount and the date is within 5 days after the recipt date?
  # Put the recipt date and the recipt payee name into the notes field
  # link the recipt and modify the file color to something notable


=end





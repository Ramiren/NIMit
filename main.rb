

#NIMit
BOX = 4             #anzahl boxen
STICKSPROBOX = 15
FEHLERQUOTE = 10    #fehlerquote des computers in prozent

#generiert die "spielfläche" mit sticks pro box und anzahl:boxen
#in jeder box muss mindestens 1 stick enthalten sein (eine box ohne sticks macht kein sinn)
def feld_gen(sticksprobox)
  puts 'Willkommen bei NIM'
  puts
  puts 'Bestimme jede Runde eine Box.
Nimm so viele Sticks aus dieser Box raus, wie du willst, aber mindestens einen.
Es gewinnt, wer den oder die letzten Sticks herausnimmt'
  puts
  feld = Array.new
  ::BOX.times {feld.push(rand(sticksprobox) + 1)}
  puts 'Startfeld wurde erstellt: '
  puts
  c = 0; feld.each {|x| puts "Box #{c += 1} = #{x}"}
  puts
  feld
end


#computer bestimmt seinen nächsten zug (die allwissende sau!)
def computer(feld)

  puts "Computer ist am Zug"
  # wenn xor = 0 ist (ein zug muss gemacht werden!) oder der computer macht ein fehler (je nach fehlerquote)
  if feld.inject {|u, x| u ^ x}.zero? || rand(100) <= ::FEHLERQUOTE

    puts
    zbox = rand(feld.length)
    feld[zbox] -= rand(feld[zbox] + 1)
    c = 0; feld.each {|a| puts "Box #{c += 1} = #{a}"}
    puts
    return feld

  else
    #wenn xor != 0 (feld wird manipuliert bis xor=0)
    feld_neu = Array.new(feld)
    xor = feld_neu.inject {|u, x| u ^ x}
    box = 0; ::BOX.times do

      until xor.zero?
        if feld_neu[box] == 0
          feld_neu[box] += feld[box]
          box += 1
        else
          feld_neu[box] -= 1
          xor = feld_neu.inject {|u, x| u ^ x}
        end
      end
    end
  end


  #ausgabe
  puts
  c = 0; feld_neu.each {|a| puts "Box #{c += 1} = #{a}"}
  puts
  feld_neu
end

#zug des menschlichen spielers
def spieler(feld)
  puts 'Spieler ist am Zug'
  puts
  print 'Welche Box? '
  begin
  boxauswahl = Integer(gets.chomp)
   
  rescue
    print 'Nur Zahlen, bitte. Welche Box? '
    retry
  end
  
  if feld[boxauswahl-1] == 0 
      box_ist_leer = true  #box ist leer
    else 
    box_ist_leer = false #box ist nicht leer
    end
  until boxauswahl <= (feld.length) && boxauswahl > 0 && box_ist_leer == false
    print 'Gibt es nicht oder ist schon leer. Welche Box? '
    begin
    boxauswahl = Integer(gets.chomp)
      if feld[boxauswahl-1] == 0 
      box_ist_leer = true  #box ist leer
    else 
    box_ist_leer = false #box ist nicht leer
    end
    
    rescue
      print 'Nur Zahlen, bitte. Welche Box? '
      retry
    end
  end
  boxauswahl -= 1

  print 'Wieviele raus?  '
  begin
  raus = Integer(gets.chomp)
  rescue
    print 'Nur Zahlen, bitte. Wieviele raus?  '
  retry
end
  until raus <= feld[boxauswahl] && raus > 0
    print 'Zu hoch oder zu tief. Wieviele raus?  '
    begin
    raus = Integer(gets.chomp)
    rescue
      print 'Nur Zahlen, bitte. Wieviele raus?  '
      retry
  end
  end
  puts
  feld[boxauswahl] -= raus
  c = 0 ; feld.each {|a| puts "Box #{c += 1 } = #{a}"}
  puts
  feld

end

#start
startfeld = feld_gen(::STICKSPROBOX)
zug = 1
puts "Zug: #{zug}"


#bestimmt ob computer oder spieler beginnt
wurf = rand(2)
if wurf == 0
  computer = false
  feld = computer(startfeld)
  zug += 1
  puts "Zug: #{zug}"
else
  puts
  computer = true
  feld = spieler(startfeld)
  zug += 1
  puts "Zug: #{zug}"
end


#schlaufe bis alle boxen leer sind
until feld.inject(:+).zero?
  if computer

    computer = false
    feld = computer(feld)
    zug += 1
    puts "Zug: #{zug}"
  else

    computer = true
    feld = spieler(feld)
    zug += 1
    puts "Zug: #{zug}"
  end


end


#spielende
if computer
  puts "Computer verliert"
  puts 
  puts "Es wird Kuchen geben!"
else
  puts "Spieler verliert"
  puts
  puts "game over".upcase!
end







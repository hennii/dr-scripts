loop do 
    echo "...listening for idle message"
    wait_for "YOU HAVE BEEN IDLE TOO LONG. PLEASE RESPOND"
    echo "...heard idle message, lets AFK this thing"
    put "EXP"
end
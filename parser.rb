names=[]

File.open('names').each_line{ |s|
  s.strip!
  names.push(s.upcase) if s.length > 0
}

pairingMatrix = {}

names.each{ |name1|
    names.each{ |name2|
        pairingMatrix[name1] = {} if pairingMatrix[name1] == nil
        pairingMatrix[name1][name2] = 0
    }
}





def printMatrix (names, pairingMatrix)
    print "<table>"
    print "<tr><td>-</td>"
    names.each{|name| print "<td>#{name}</td>"}
    print "</tr>\n"

    names.each{ |name1|
        print "<tr>"
        print "<td>#{name1}</td>"
        names.each{ |name2|
            print "<td>#{pairingMatrix[name1][name2]}</td>"
        }
        print "</tr>\n"
    }
    print "</table>"
end

printMatrix(names, pairingMatrix)

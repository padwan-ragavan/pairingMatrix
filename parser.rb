names=[]

File.open('names').each_line{ |s|
  s.strip!
  names.push(s.upcase) if s.length > 0
}

pairingMatrix = {}

names.each{ |name1|
    names.each{ |name2|
        pairingMatrix[name1] = {} if pairingMatrix[name1] == nil
        pairingMatrix[name1][name2] = {}
        pairingMatrix[name1][name2]["count"] = 0
    }
}


File.open('glog').each_line{ |s|
  s.strip!
  commitDate = /@@(\d+-\d+-\d+)/.match(s)[1]
  matches = /&&\W?(\w+)\W+([a-z]+)?/i.match(s)
  name1 = matches[1]
  name2 = matches[2]
  name2 = name1 if name2==nil or name2.length==0
  commitNames = []
  commitNames.push(name1.upcase)
  commitNames.push(name2.upcase)
  commitNames.sort()
  pairingMatrix[commitNames[0]][commitNames[1]]["count"] = pairingMatrix[commitNames[0]][commitNames[1]]["count"] + 1 if pairingMatrix[commitNames[0]][commitNames[1]]["date"] != commitDate
  pairingMatrix[commitNames[0]][commitNames[1]]["date"] = commitDate
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
            print "<td>#{pairingMatrix[name1][name2]["count"]}</td>"
        }
        print "</tr>\n"
    }
    print "</table>"
end

def printCSV (names, pairingMatrix)
	print ","
	names.each{|name| print "#{name},"}
	print "\n"
	names.each{ |name1|
        print "#{name1},"
        names.each{ |name2|
            print "#{pairingMatrix[name1][name2]["count"]},"
        }
	print "\n"
    }
end

printCSV(names, pairingMatrix)

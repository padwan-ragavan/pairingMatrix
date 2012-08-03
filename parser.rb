$names=[]
$pairingMatrix = {}

def addNamesIfNotPresent (commitNames)
	commitNames.each{ |name|
			$names.push(name.upcase) if !$names.include? name
	}
end

def addPairWhenNotSameDay (commitNames, commitDate)
	name1 = commitNames[0]
	name2 = commitNames[1]
	$pairingMatrix[name1] = {} if $pairingMatrix[name1] == nil
	if $pairingMatrix[name1][name2] == nil
		$pairingMatrix[name1][name2] = {} 
		$pairingMatrix[name1][name2]["count"] = 0
	end
	$pairingMatrix[name1][name2]["count"] = $pairingMatrix[name1][name2]["count"] + 1 if $pairingMatrix[name1][name2]["date"] != commitDate
	$pairingMatrix[name1][name2]["date"] = commitDate
end

def printHTML ()
    print "<table>"
    print "<tr><td>-</td>"
    $names.each{|name| print "<td>#{name}</td>"}
    print "</tr>\n"
	
    $names.each{ |name1|
        print "<tr>"
        print "<td>#{name1}</td>"
        $names.each{ |name2|
            print "<td>#{$pairingMatrix[name1][name2]["count"]}</td>"
        }
        print "</tr>\n"
    }
    print "</table>"
end

def printCSV ()
	print ","
	$names.each{|name| print "#{name},"}
	print "\n"
	$names.each{ |name1|
        print "#{name1},"
        $names.each{ |name2|
			print "#{$pairingMatrix[name1][name2]["count"]}" if $pairingMatrix[name1][name2] != nil
			print ","
        }
	print "\n"
    }
end

def removeNoise(threshold)
	$pairingMatrix.each{ |k,v|
		sum=0		
		$pairingMatrix[k].each { |pk,pv| sum+=pv["count"] }
		$names.delete(k) if sum <= threshold
	}
end

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
  addNamesIfNotPresent(commitNames)
  addPairWhenNotSameDay(commitNames, commitDate)
  addPairWhenNotSameDay(commitNames.reverse, commitDate)
}

removeNoise(ARGV[0].to_i > 0 ? ARGV[0].to_i : 4)
printCSV()

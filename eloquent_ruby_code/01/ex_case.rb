##

def case_no_semi(title)
  # #start no_semi
  author = case title
  when "War And Peace"
    puts "Tolstoy"
  when "Romeo And Juliet"
    puts "Shakespeare"
  else
    puts "Don't know"
  end
  # #end no_semi
end

def case_semi(title)
  # #start semi
  case title
  when "War And Peace" then puts "Tolstoy"
  when "Romeo And Juliet" then puts "Shakespeare"
  else puts "Don't know"
  end
  # #end semi
end

# This is a quick hack to create Bingo cards using Javascript terms.
require 'rubygems'
require 'prawn'

CELL_HEIGHT = 70
CELL_WIDTH = 100

f = File.new 'words.txt'
s = f.read
ALL_WORDS = s.split(/\n/).select{|x| x.length > 0}



def get_words
  words = []
  while words.length < 25
    position = rand(ALL_WORDS.length-1)
    word = ALL_WORDS[position]
    words << word unless words.include? word
  end
  words
end

def show
  puts cursor
end

def get_word(words,row,col)
  index = row*5 + col
  words[index]
end

def draw_card(words)
  page_width = bounds.width
  left_edge = (bounds.width - CELL_WIDTH*5)/2
  bounding_box [left_edge,0], :width => CELL_WIDTH*5 do
     
    bounding_box [0, 720], :width => 5*CELL_WIDTH do
      text "JavaScript Bingo", :align => :center, :size => 24, :style => :bold, :character_spacing => 4
      pad_bottom(10) { text "Pete Campbell   /   pete@sumirolabs.com   /   github.com/campbell", :align => :center, :size => 12 }
      stroke_horizontal_rule
    end
    
    rotate(-25, :origin => [500,700]) do
      image 'guaranteed.jpg', :width => 100, :scale => true, :at => [450, 740]
    end
  
    %w(B I N G O).each_with_index do |letter, index|
      draw_box(letter, CELL_WIDTH*index, -50, false, {:size => 20, :style => :bold})
    end
    (0..4).each do |row|
      (0..4).each do |col|
        word = get_word(words,row,col)
        x = CELL_WIDTH*row
        y = CELL_HEIGHT*col
        draw_box(word,x,y)
      end
    end

    column_box([0,cursor-30], :columns => 5, :align => :center, :width => bounds.width) do
      text ALL_WORDS.sort.join("\n"), :size => 10
    end
    draw_footer
    
  end
end

def draw_box(str, x, y, stroke = true, options = {})
  bounding_box [x, 610-y], :height => CELL_HEIGHT, :width => CELL_WIDTH do
    text str, options.merge({:align => :center, :valign => :center})
    stroke_bounds if stroke
  end
end

def draw_footer
  pad(20) { text "JavaScript Bingo\n\nBy Pete Campbell\npete@sumirolabs.com\n\n(c) 2012", :align => :center }
end

WORDS = get_words

Prawn::Document.generate("bingo-cards.pdf") do
  (0..99).each do |page|
    draw_card(get_words)
  end
end
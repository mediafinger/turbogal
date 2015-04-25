require 'rubygems'

require 'awesome_print'
AwesomePrint.irb!
AwesomePrint.defaults = {
  :indent => 2
}

require 'irb/ext/save-history'
IRB.conf[:SAVE_HISTORY] = 200
IRB.conf[:HISTORY_FILE] = '.irb-history'

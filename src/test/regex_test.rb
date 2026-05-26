# encoding: UTF-8
require 'net/smtp'
require 'date'
require 'time'

d ="https://creativecommons.org/licenses/by-nd/4.0/"

if d.match(/^https:\/\/creativecommons.org\//) 
    pp "CC-#{ d.split('/').last(2).join('-').upcase() }"
end
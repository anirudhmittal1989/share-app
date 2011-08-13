require 'rubygems'
require 'net/dav'
require 'pony'

class HomeController < ApplicationController
  def index
    dav = Net::DAV.new("http://10.23.10.162:8080/webdav/", :curl => false)
    dav.verify_server = false
    dav.credentials('psalas',ENV['DAVPASS'])
    
    #
    @list = [ ]

    #dav.find('.',:recursive=>true,:suppress_errors=>true,:filename=>/\.html|\.xml$/) do | item |
    dav.find('.',:recursive=>true,:suppress_errors=>true) do | item |
      puts "Checking: " + item.url.to_s
      @list.push item
      
      if( item.content =~ /www.wrong.com/ )
        item.content = item.content.gsub("www.wrong.com", "www.right.com")
        puts "Updated: " + item.url.to_s
      end
    end
    
    # Send an email
    Pony.mail(:to => 'psalas@proofpoint.com',
              :from => 'psalas@proofpoint.com',
              :subject => 'Hello',
              :via => :smtp,
              :via_options => {
                :address => 'ultraman.lab.proofpoint.com',
                :port => '25',
                #:enable_starttls_auto => true,
                #:user_name => 'psalas',
                #:password => '',
                #:authentication => :plain,
                #:domain => "HELO",
              }
              )
  end

end

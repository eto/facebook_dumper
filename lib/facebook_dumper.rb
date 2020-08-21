#!/usr/bin/ruby -w
# coding: utf-8

require "facebook_dumper/version"

require 'pathname'
require 'open-uri'
require 'nokogiri'
require 'pp'
require "rexml/document"

module FacebookDumper
  class Error < StandardError; end

  class Person
    def initialize
      #@uid = 0
      @url = ""
      @name = ""
      @imgsrc = ""
      @friends_mutual = 0
      #@friends_num = 0
    end
    attr_accessor :url
    attr_accessor :name
    attr_accessor :imgsrc
    attr_accessor :friends_mutual
    #attr_accessor :uid, :url, :name, :friends_num, :mutual_friends_num

    def inspect
      #"#{@url}	#{@name}	#{@friends_mutual}	#{@imgsrc}"
      "#{@url}	#{@name}	#{@friends_mutual}"
    end
    def <=> other
      #return @uid <=> other.uid
      return @url <=> other.url
    end
  end

  class FacebookFriendsDumper
    def initialize
      @friends = []
    end

    def run(argv)
      file = argv[0]
      p file
      extract_from_file file
      out = friends_list
      open("facebook-friends.txt", "w") {|f| f.print out}
    end

    def take1
      doc.search(:img).each {|node|
        node.remove_attribute("alt")
        node.remove_attribute("role")
      }
      doc.search(:div).each {|node|
        node.remove_attribute("data-ft")
        node.remove_attribute("data-testid")
        node.remove_attribute("style")
      }
      doc.search(:noscript).map &:remove
      doc.search(:a).each {|node|
=begin
        node.remove_attribute("data-gt")
        node.remove_attribute("ajaxify")
        node.remove_attribute("rel")
        node.remove_attribute("role")
        node.remove_attribute("data-hover")
        node.remove_attribute("data-tooltip-uri")
        node.remove_attribute("tabindex")
        node.remove_attribute("aria-hidden")
        node.remove_attribute("data-profileid")
        node.remove_attribute("data-flloc")
        node.remove_attribute("data-unref")
        node.remove_attribute("data-floc")
=end
        node.remove_attribute("data-hovercard")
        node.remove_attribute("data-hovercard-prefer-more-content-show")
        node.remove_attribute("style")
        node.remove_attribute("aria-haspopup")
      }
      doc.search(:li).each {|node|
        node.remove_attribute("data-ft")
        node.remove_attribute("data-gt")
        node.remove_attribute("data-alert-id")
      }
      doc.search(:button).each {|node|
        node.remove_attribute("class")
        node.remove_attribute("data-flloc")
        node.remove_attribute("data-profileid")
        node.remove_attribute("type")
        node.remove_attribute("data-cancelref")
        node.remove_attribute("data-floc")
      }
      #open("t3.html", "w") {|f| f.print doc.to_s }
      open("t4.html", "w") {|f| f.print doc.to_xml(:indent => 2) }

      num = 0
      @friends = []
      doc.xpath('//li[@class="_698"]').each {|node|	#<li class="_698">
        node.search(:button).map &:remove
        node.search(:span).each {|n|
          n.remove_attribute("class")
          n.remove_attribute("aria-hidden")
        }

        person = Person.new
        node.search(:div).each {|n|
          if n.attribute('class').value == "uiProfileBlockContent"
            n.search(:a).each {|a|
              text = a.inner_text
              if text =~ /共通の友達(.+)人/
                person.mutual_friends_num = $1.gsub(",", "").to_i
              elsif text =~ /友達(.+)人/
                person.friends_num = $1.gsub(",", "").to_i
              elsif a.attribute('ajaxify') && a.attribute('ajaxify').value =~ /\/ajax\/friends\/inactive\/dialog\?id=(.+)/
                #<a href="https://www.facebook.com/etocom/friends#" rel="dialog" ajaxify="/ajax/friends/inactive/dialog?id=100008321654013" role="button">干場 隆志
                #ajaxify="/ajax/browser/dialog/mutual_friends/?uid=1036721103"
                uid = $1.to_i
                person.uid = uid
                person.url = "https://www.facebook.com/profile.php?id=#{uid}"
                person.name = a.inner_text.chomp
                person.friends_num = -1
              elsif a.attribute('data-gt')
                person.name = text.chomp
                url = a.attribute('href').value
                url.gsub!("?fref=profile_friend_list&hc_location=friends_tab", "")
                url.gsub!("&fref=profile_friend_list&hc_location=friends_tab", "")
                url.gsub!("?fref=pb&hc_location=friends_tab", "")
                url.gsub!("&fref=pb&hc_location=friends_tab", "")
                person.url = url
              else
                # ignore
              end
            }
            #friends << [friend_url, friend_name, friend_num, friend_mutual]
            @friends << person
          end
        }
        num += 1
      }
      #p num	#4995
      return @friends
    end

    def parse_a_person(gpa)
      person = Person.new
      gpa.search(:img).each {|img|
        person.imgsrc = img.attribute('src').value
        pa = img.parent
        if pa.name != "a"
          gpa.search(:span).each {|span|
            text = span.inner_text
            unless text =~ /^友達$/
              person.name = text
              person.url = "no_longer_on_Facebook"
            end
          }
          return person	# return here, since the user is no longer on Facebook.
        end
      }
      gpa.search(:a).each {|a|
        if a.attribute('tabindex').value == "0"
          url = a.attribute('href').value
          text = a.inner_text
          if url =~ /friends_mutual/
            if text =~ /共通の友達(.+)人/
              person.friends_mutual = $1.gsub(",", "").to_i
            end
          else
            person.url = url
            person.name = text
          end
          #f.puts [person.url, person.name]
        end
        #f.puts a.to_html
      }
      return person
    end

    def extract_from_file(file)
      charset = nil
      html = ""
      open(file) {|f|
        html = f.read
      }
      #open("t1.html", "w") {|f| f.print html }

      doc = Nokogiri::HTML.parse(html, nil, charset)
      #open("t2.html", "w") {|f| f.print doc.to_s }

      doc.search(:meta).map &:remove
      doc.search(:link).map &:remove
      doc.search(:style).map &:remove
      doc.search(:script).map &:remove
      doc.search(:svg).map &:remove
      doc.search(:div).each {|node|
        node.remove_attribute("class")
      }
      doc.search(:span).each {|node|
        node.remove_attribute("class")
      }
      doc.search(:i).each {|node|
        node.remove_attribute("class")
      }
      doc.search(:a).each {|node|
        node.remove_attribute("class")
      }
      doc.search(:label).each {|node|
        node.remove_attribute("class")
      }
      doc.search(:img).each {|node|
        node.remove_attribute("class")
      }
      doc.search(:input).each {|node|
        node.remove_attribute("class")
      }
      doc.search(:ul).each {|node|
        node.remove_attribute("class")
      }
      doc.search(:li).each {|node|
        node.remove_attribute("class")
      }
      #open("t3.html", "w") {|f| f.print doc.to_s }

      #$f = open("t4.html", "w")

      num = 0
      @friends = []
      doc.xpath('//div[@aria-label="友達"]').each {|node|
        gpa = node.parent.parent	# get grand parent
        person = parse_a_person(gpa)
        #$f.puts person.inspect
        #$f.puts "----------------------------------------------------------------------"
        @friends << person
        num += 1
      }
      #$f.puts num	# 4993
      #$f.close

      return @friends
    end

    def friends_list_take1
        ar << [p.url, p.name, p.num]
        if num < 0
          out << "#{p.url}	#{p.name}	-1\n"
        else
          out << "#{p.url}	#{p.name}\n"
        end
    end

    def friends_list
      out = ""
      @friends.sort.each {|p|
        out << p.inspect + "\n"
      }
      return out
    end
  end
end

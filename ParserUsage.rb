require 'nokogiri'
require 'open-uri'
require 'mechanize'
require_relative 'model/User'
require_relative 'model/Cafe'
require_relative 'Cafe'


module CafeParser
  class ParserUsage

    def can_parse?(site)
      false
    end

    def create(site)
      nil
    end

    @@parsers = []

    def self.add_parser(p)
      @@parsers << p unless @@parsers.include? p
    end

    def self.parsers
      @@parsers
    end

    def self.parser_for(site)
      @@parsers.each do |parser|
        return parser.create(site) if parser.can_parse?(site)
      end
    end

    def self.load(dirname)
      Dir.open(dirname).each do |fn|
        next unless fn =~ /Parser\.rb$/
        require File.join(dirname,fn)
      end
    end

    def self.inherited(parser)
      self.add_parser(parser)
    end
  end

  ParserUsage.load(File.join(File.dirname(__FILE__),'parsers'))
end
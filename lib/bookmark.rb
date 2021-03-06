require 'pg'

class Bookmark

  attr_reader :id, :title, :url

  def initialize(id:, title:, url:)
    @id = id
    @title = title
    @url = url
  end

  def self.all
    if ENV['RACK_ENV'] == 'test'
      connection = PG.connect(dbname: 'bookmark_challenge_test')
    else
      connection = PG.connect(dbname: 'bookmark_challenge')
    end

    result = connection.exec("SELECT * FROM bookmarks;")
    result.map { |bookmark|
      Bookmark.new(id: bookmark['id'], title: bookmark['title'], url: bookmark['url'])
    }
  end

  def self.create(url:, title:)
    if ENV['RACK_ENV'] == 'test'
      connection = PG.connect(dbname: 'bookmark_challenge_test')
    else
      connection = PG.connect(dbname: 'bookmark_challenge')
    end

    result = connection.exec("INSERT INTO bookmarks (url, title) VALUES('#{url}', '#{title}') RETURNING id, title, url;")
    Bookmark.new(id: result[0]['id'], title: result[0]['title'], url: result[0]['url'])
  end

  def self.delete(id:)
    if ENV['RACK_ENV'] == 'test'
      connection = PG.connect(dbname: 'bookmark_challenge_test')
    else
      connection = PG.connect(dbname: 'bookmark_challenge')
    end
    connection.exec("DELETE FROM bookmarks WHERE id = #{id}")

  end

end

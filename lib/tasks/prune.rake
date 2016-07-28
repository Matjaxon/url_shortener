namespace :url do
  task prune: :environment do
    puts "Pruning old urls..."
    ShortenedUrl.prune
  end
end

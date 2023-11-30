function sgpt --wraps=sgpt
    OPENAI_API_KEY=(op read -n op://Personal/openai.com/terminal -n) command sgpt $argv
end


-- NOTE: To expose ollama ports, follow this https://github.com/ollama/ollama/blob/main/docs/faq.md
return {
  'David-Kunz/gen.nvim',
  config = function()
    opts = {
      -- model = 'codellama:7b-code', -- The default model to use.
      model = 'codellama:latest', -- The default model to use.
      host = '192.168.1.74', -- The host running the Ollama service.
      port = '11434', -- The port on which the Ollama service is listening.
      quit_map = 'q', -- set keymap for close the response window
      retry_map = '<c-r>', -- set keymap to re-send the current prompt
      init = function(options)
        pcall(io.popen, 'ollama serve > /dev/null 2>&1 &')
      end,
      -- Function to initialize Ollama
      command = function(options)
        local body = { model = options.model, stream = true }
        return 'curl --silent --no-buffer -X POST http://' .. options.host .. ':' .. options.port .. '/api/chat -d $body'
      end,
      -- The command for the Ollama service. You can use placeholders $prompt, $model and $body (shellescaped).
      -- This can also be a command string.
      -- The executed command must return a JSON object with { response, context }
      -- (context property is optional).
      -- list_models = '<omitted lua function>', -- Retrieves a list of model names
      display_mode = 'float', -- The display mode. Can be "float" or "split" or "horizontal-split".
      show_prompt = false, -- Shows the prompt submitted to Ollama.
      show_model = true, -- Displays which model you are using at the beginning of your chat session.
      no_auto_close = false, -- Never closes the window automatically.
      debug = true, -- Prints errors and the command which is run.
    }
    require('gen').setup(opts)

    -- add prompts
    require('gen').prompts['Elaborate_Text'] = {
      prompt = 'Elaborate the following text:\n$text',
      replace = true,
    }
    require('gen').prompts['Fix_Code'] = {
      prompt = 'Fix the following code. Only ouput the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```',
      replace = true,
      extract = '```$filetype\n(.-)```',
    }
    require('gen').prompts['Gen Code'] = {
      prompt = 'Generate $filetype code following precisely the instruction $input. Only ouput the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```',
      replace = true,
      extract = '```$filetype\n(.-)```',
    }
  end,
}

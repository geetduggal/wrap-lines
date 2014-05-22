module.exports =
    activate: ->
        atom.workspaceView.command "wrap-lines:wrap", => @wrap()
        atom.workspaceView.command "wrap-lines:unwrap", => @unwrap()

    wrap: ->
        editor = atom.workspace.activePaneItem
        selection = editor.getSelection()
        stext = selection.getText()

        if stext.length > 0
            paras = (para.split(/\s+/) for para in stext.split(/\n\n+/))
        else
            paras = [editor.lineForBufferRow(editor.getCursorScreenRow()).split(/\s+/)]
            editor.selectLine()
            selection = editor.getSelection()

        wrapped = ""
        for words in paras
            charcount = 0
            for w in words
                n = w.length + 1
                if charcount + n >= 78
                    wrapped += "\n"
                    charcount = 0
                wrapped += w + " "
                charcount += n
            wrapped += "\n\n"

        selection.insertText(wrapped.substring(0,wrapped.length-1))

    unwrap: ->
        editor = atom.workspace.activePaneItem
        selection = editor.getSelection()
        stext = selection.getText()
        # TODO: find better dummy string than "-0-" for a paragraph split
        selection.insertText(stext.replace(/\n\n+/g, "-0-").replace(/\n/g, " ").replace(/-0-/g, "\n\n")+"\n")

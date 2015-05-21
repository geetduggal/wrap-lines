{Point, Range} = require 'atom'
module.exports =
    configDefaults:
        lineLength: 78

    activate: ->
        atom.workspaceView.command "wrap-lines:wrap", => @wrap()
        atom.workspaceView.command "wrap-lines:unwrap", => @unwrap()

    wrap: ->
        editor = atom.workspace.activePaneItem
        selection = editor.getSelection()
        stext = selection.getText()
        lineLength = atom.config.get("wrap-lines.lineLength")

        if stext.length > 0
            paras = (para.split(/\s+/) for para in stext.split(/\n\n+/))
        else
            # paras = [editor.lineForBufferRow(editor.getCursorScreenRow()).split(/\s+/)]
            # editor.selectLine()
            # selection = editor.getSelection()
            start = editor.getCursorBufferPosition()
            {row, column} = start
            scanRange = [[row, column], [0,0]]
            paraBegin = new Point(0, 0)
            zero = new Point(0,0)
            editor.backwardsScanInBufferRange /\n\n+/, scanRange, ({range, stop}) =>
                paraBegin = range.end
                stop()

            scanRange = [start, editor.getEofBufferPosition()]

            {row, column} = editor.getEofBufferPosition()
            paraEnd = new Point(row, column - 1)

            editor.scanInBufferRange /\n\n+/, scanRange, ({range, stop}) =>
                paraEnd = range.start
                stop()

            editor.setSelectedBufferRange([paraBegin,paraEnd])
            selection = editor.getSelection()
            paras = [selection.getText().split(/\s+/)]


        wrapped = ""
        for words in paras
            charcount = 0
            for w in words
                n = w.length + 1
                if charcount + n >= lineLength
                    wrapped += "\n"
                    charcount = 0
                wrapped += w + " "
                charcount += n
            wrapped += "\n\n"

        selection.insertText(wrapped.substring(0,wrapped.length-2))

    unwrap: ->
        editor = atom.workspace.activePaneItem
        selection = editor.getSelection()
        stext = selection.getText()
        # TODO: find better dummy string than "-0-" for a paragraph split
        selection.insertText(stext.replace(/\n\n+/g, "-0-").replace(/\n/g, " ").replace(/-0-/g, "\n\n")+"\n")

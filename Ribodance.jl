function start_game(; hit_range = 0.5, speed = 0.05)
   #Scene layout
    f = Figure()

    ax = Axis(f[1, 1])
    xlims!(ax, low = -10, high = 10)
    ylims!(ax, low = -5, high = 15)

    ax2 = Axis(f[1, 1], yticklabelcolor = :red, yaxisposition = :right)
    xlims!(ax2, low = -10, high = 10)
    ylims!(ax2, low = -5, high = 15)
    hidedecorations!(ax)
    hidedecorations!(ax2)

    #Dotted line1
    xs = -10:1:10
    ys = 0.5 * ones(length(xs))
    lines!(ax2, xs, ys, linewidth = 3, color = :black, linestyle = :dash)

#=
    #optional second Dotted line
    xs = -10:1:10
    ys = -0.5* ones(length(xs))
    lines!(ax2, xs, ys, linewidth = 3, color = :black, linestyle = :dash)
=#

    #mRNA Sequenz
    sequence = rand(('A','C','G','T'),15)
    has_counted = fill(false, length(sequence))

    #Keyboardevents
    Label(f[1, 1], fontsize=30, tellheight=false, tellwidth=false,
        halign = :right,valign = :bottom,"")

        #Highscore 
         highscore = Observable(0)
         Label(f[1, 1], fontsize=30, tellheight=false, tellwidth=false,
         halign = :left,valign = :top,"Highscore: $(highscore[])")

    on(events(f).keyboardbutton) do event
        pressed_letter = ""
        if event.action == Keyboard.press
            if ispressed(f, Keyboard.up)
                pressed_letter = f.content[3].text[] = "A"
            elseif ispressed(f, Keyboard.down)
                pressed_letter = f.content[3].text[] = "C"
            elseif ispressed(f, Keyboard.right)
                pressed_letter = f.content[3].text[] = "T"
            elseif ispressed(f, Keyboard.left)
                pressed_letter = f.content[3].text[] = "G"
            end
        end
        if event.action == Keyboard.release
            f.content[3].text[] = ""
            f.content[3].color[] = colorant"black"
        end
        ind = findfirst( x-> -hit_range < x[1][][1][2] < hit_range, f.content[1].scene.plots)
        if ind === nothing
            return
        else
            letter = f.content[1].scene.plots[ind].text[]
        end
        if pressed_letter == letter
             f.content[3].color[] = colorant"green"
             if !has_counted[ind]
                highscore[] += 1
                has_counted[ind] = true
             end
             f.content[4].text[] = string("Highscore: ", highscore[])
        else
            f.content[3].color[] = colorant"red"     
        end
    end


    #Loop for mRNA
    for (j, letter) in enumerate(join.(sequence))
 
            text!(ax,
            [Point2f(0, j+(j-1)÷3+20)],
             text = letter,
             color = [:blue],
             fontsize = 0.8,
             markerspace = :data,
                )         
    end
    while f.content[1].scene.plots[end][1][][1][2] > -6
        for plot in f.content[1].scene.plots
            plot[1][] -= [Point2f(0, speed)]
        end
        display(f)
        sleep(0.01)
    end
end
f = start_game(; speed = 0.05)






; script-fu-resample
; K. Clay McKell
; Resample an image at a fixed pixel size.
; 
; UPDATE LOG
; June 2012 -- 1.0 -- Working.
;

(define (script-fu-resample image drawable framewidth pixwidth custompalette numcolors)
    (let*
        (   ; Construct variables here.
            (contraction 1)
            (imwidth)
            (wentry)
        )

        (gimp-image-undo-group-start image)
        ; Define "contraction" as the ratio of the desired pixel to the width of the frame.
        (set! contraction (/ framewidth pixwidth))
        (set! imwidth (car (gimp-image-width image)))
        ; Translate the real-unit contraction into pixel contraction (used by GIMP).
        (set! wentry (round (/ imwidth contraction)))
        ; Test that new pixel size is >= 1
        (if (< wentry 1)
          (begin 
            (gimp-message "You have specified a pixel size that is smaller than the pixels in the original image.  Aborting.")
            (set! wentry 1)
          )
          ()
        )
        ; Pixelize with square pixels: Non-interactive, image, drawable, pixel width, pixel height.
        (plug-in-pixelize2 1 image drawable wentry wentry)
        ; Reduce image colors.
        (if (string-ci=? "Default" custompalette) ; custompalette is "Default" i.e. not custom.
          (begin
            ;Check custom number
            (if (> numcolors 1)
              (gimp-image-convert-indexed image 0 0 numcolors 0 0 "ignore_me")
              (begin 
                (gimp-message "Cannot downsample to less than 2 colors.  Defaulting to 2 colors.")
                (gimp-image-convert-indexed image 0 0 2 0 0 "ignore_me")
              )
            )
          )
          (begin 
            ;Index with custom palette
            (gimp-image-convert-indexed image 0 4 -1 0 0 custompalette)
          )
        )
        ; Show results.
        (gimp-image-undo-group-end image)
        (gimp-displays-flush)
    )

)

(script-fu-register "script-fu-resample"
    "Resample"
    "Sample an image at a specified pixel size and bit depth."
    "K. Clay McKell"
    "K. Clay McKell"
    "June 2012"
    "*"
    SF-IMAGE "Image" 0
    SF-DRAWABLE "Drawable" 0
    SF-VALUE "In real units (m, km, etc.), how wide is your image" "1"
    SF-VALUE "In the same units, how wide is your pixel" "1"   
    SF-PALETTE "If you would like a custom color palette, select it here.  \nIf not, leave as 'Default'" "Default"
    SF-VALUE "To only set the number of bins and \nhave the computer select which color each bin gets, \nspecify the number of bins here" "2"
)

(script-fu-menu-register "script-fu-resample" "<Image>/Image/")

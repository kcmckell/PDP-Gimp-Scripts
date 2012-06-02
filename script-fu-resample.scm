; script-fu-resample
; K. Clay McKell
; 
; UPDATE LOG
; June 2012 -- 0.1 -- Initial development.
;

(define (script-fu-resample image drawable framewidth pixwidth)
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
        ; Pixelize with square pixels: Non-interactive, image, drawable, pixel width, pixel height.
        (plug-in-pixelize2 1 image drawable wentry wentry)
        ; Show results.
        (gimp-displays-flush)
        (gimp-image-undo-group-end image)
        (gimp-image-clean-all image)
    )

)

(script-fu-register "script-fu-resample"
    "<Image>/Image/Resample"
    "Sample an image at a specified pixel size and bit depth."
    "K. Clay McKell"
    "K. Clay McKell"
    "June 2012"
    "RGB GRAY INDEXED"
    SF-IMAGE "Image" 0
    SF-DRAWABLE "Drawable" 0
    SF-VALUE "In real units (m, km, etc.), how wide is your image" "0"
    SF-VALUE "In the same units, how wide is your pixel" "0"    
)
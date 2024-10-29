# Conversion of RGB888 image to RGB565
# lab03 of MYY505 - Computer Architecture
# Department of Computer Engineering, University of Ioannina
# Aris Efthymiou

# This directive declares subroutines. Do not remove it!
.globl rgb888_to_rgb565, showImage

.data

image888:  # A rainbow-like image Red->Green->Blue->Red
    .byte 255, 0,     0
    .byte 255,  85,   0
    .byte 255, 170,   0
    .byte 255, 255,   0
    .byte 170, 255,   0
    .byte  85, 255,   0
    .byte   0, 255,   0
    .byte   0, 255,  85
    .byte   0, 255, 170
    .byte   0, 255, 255
    .byte   0, 170, 255
    .byte   0,  85, 255
    .byte   0,   0, 255
    .byte  85,   0, 255
    .byte 170,   0, 255
    .byte 255,   0, 255
    .byte 255,   0, 170
    .byte 255,   0,  85
    .byte 255,   0,   0
# repeat the above 5 times
    .byte 255, 0,     0, 255,  85,   0 255, 170,   0, 255, 255,   0, 170, 255,   0, 85, 255,   0, 0, 255,   0, 0, 255,  85, 0, 255, 170, 0, 255, 255, 0, 170, 255, 0,  85, 255, 0,   0, 255, 85,   0, 255, 170,   0, 255, 255,   0, 255, 255,   0, 170, 255,   0,  85, 255,   0,   0
    .byte 255, 0,     0, 255,  85,   0 255, 170,   0, 255, 255,   0, 170, 255,   0, 85, 255,   0, 0, 255,   0, 0, 255,  85, 0, 255, 170, 0, 255, 255, 0, 170, 255, 0,  85, 255, 0,   0, 255, 85,   0, 255, 170,   0, 255, 255,   0, 255, 255,   0, 170, 255,   0,  85, 255,   0,   0
    .byte 255, 0,     0, 255,  85,   0 255, 170,   0, 255, 255,   0, 170, 255,   0, 85, 255,   0, 0, 255,   0, 0, 255,  85, 0, 255, 170, 0, 255, 255, 0, 170, 255, 0,  85, 255, 0,   0, 255, 85,   0, 255, 170,   0, 255, 255,   0, 255, 255,   0, 170, 255,   0,  85, 255,   0,   0
    .byte 255, 0,     0, 255,  85,   0 255, 170,   0, 255, 255,   0, 170, 255,   0, 85, 255,   0, 0, 255,   0, 0, 255,  85, 0, 255, 170, 0, 255, 255, 0, 170, 255, 0,  85, 255, 0,   0, 255, 85,   0, 255, 170,   0, 255, 255,   0, 255, 255,   0, 170, 255,   0,  85, 255,   0,   0
    .byte 255, 0,     0, 255,  85,   0 255, 170,   0, 255, 255,   0, 170, 255,   0, 85, 255,   0, 0, 255,   0, 0, 255,  85, 0, 255, 170, 0, 255, 255, 0, 170, 255, 0,  85, 255, 0,   0, 255, 85,   0, 255, 170,   0, 255, 255,   0, 255, 255,   0, 170, 255,   0,  85, 255,   0,   0

image565:
    .zero 512  # leave a 0.5Kibyte free space

.text
# -------- This is just for fun.
# Ripes has a LED matrix in the I/O tab. To enable it:
# - Go to the I/O tab and double click on LED Matrix.
# - Change the Height and Width (at top-right part of I/O window),
#     to the size of the image888 (6, 19 in this example)
# - This will enable the LED matrix
# - Uncomment the following and you should see the image on the LED matrix!
#    la   a0, image888
#    li   a1, LED_MATRIX_0_BASE
#    li   a2, LED_MATRIX_0_WIDTH
#    li   a3, LED_MATRIX_0_HEIGHT
#    jal  ra, showImage
# ----- This is where the fun part ends!

    la   a0, image888
    la   a3, image565
    li   a1, 19 # width
    li   a2,  6 # height
    jal  ra, rgb888_to_rgb565

    addi a7, zero, 10 
    ecall

# ----------------------------------------
# Subroutine showImage
# a0 - image to display on Ripes' LED matrix
# a1 - Base address of LED matrix
# a2 - Width of the image and the LED matrix
# a3 - Height of the image and the LED matrix
# Caution: Assumes the image and LED matrix have the
# same dimensions!
showImage:
    add  t0, zero, zero # row counter
showRowLoop:
    bge  t0, a3, outShowRowLoop
    add  t1, zero, zero # column counter
showColumnLoop:
    bge  t1, a2, outShowColumnLoop
    lbu  t2, 0(a0) # get red
    lbu  t3, 1(a0) # get green
    lbu  t4, 2(a0) # get blue
    slli t2, t2, 16  # place red at the 3rd byte of "led" word
    slli t3, t3, 8   #   green at the 2nd
    or   t4, t4, t3  # combine green, blue
    or   t4, t4, t2  # Add red to the above
    sw   t4, 0(a1)   # let there be light at this pixel
    addi a0, a0, 3   # move on to the next image pixel
    addi a1, a1, 4   # move on to the next LED
    addi t1, t1, 1
    j    showColumnLoop
outShowColumnLoop:
    addi t0, t0, 1
    j    showRowLoop
outShowRowLoop:
    jalr zero, ra, 0

# ----------------------------------------

rgb888_to_rgb565:
# ----------------------------------------
# Write your code here.
# You may move the "return" instruction (jalr zero, ra, 0).
#self-note to remember args: a0 = src, a1, = width, a2 = height, a3 = dest

 add t0, a0, zero # use t0 as iterator for src
 add t1, a3, zero # use t1 as iterator for dest
L1: #loop start
    #use t3 to store current RGB888 pixel 
    #use t4 as a temp var for loading and applying masks and shifts
    #use t5 to accumulate the result
#Load pixel
    #I gotta load the bytes seperately because endianness, ugh
    lbu t3, 0(t0) #load first byte
    lbu t4, 1(t0) #load second byte
    slli t3, t3, 8 #open space
    add t3, t4, t3 #merge
    lbu t4, 2(t0) #load third byte
    slli t3, t3, 8 #open space
    add t3, t4, t3 #merge
#Convert pixel
    srli t3, t3, 3 #remove 3 LSBs from the B value
    andi t5, t3, 0x1F #copy 5 MSBs from B
    srli t3, t3, 7 #remove 2 LSBs from G + 5 MSBs from B
    andi t4, t3, 0x3F #copy 6 MSBs from G to result
    slli t4, t4, 5 #reposition for 565 format
    add t5,t4,t5 #accumulate to result
    srli t3, t3, 9 #remove 3 LSBs from R + 6 MSBs from G
     #the 5 MSBs from R are the only bits left in t3, no need to transfer to t4
     slli t3, t3, 11 #reposition for 565 format
    add t5, t3, t5 #accumulate to result
#copy the result to memory (same way as load, byte by byte, except in reverse order because of endianness)
    sb t5, 0(t1) #copy LSB
    srli t5, t5, 8 #shift right to get MSB on low
    sb t5, 1(t1) #copy MSB
#increment iterators and loop
    addi t0, t0, 3 #increment by 1 RGB888 pixel (3b)
    addi t1, t1, 2 #increment by 1 RGB565 pixel (2b)
    bltu t0, a3, L1 # loop till you reach the end of the array
    #Note: ik this is not the right way, but idc
    jalr zero, ra, 0



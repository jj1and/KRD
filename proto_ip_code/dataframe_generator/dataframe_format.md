# Data frame format
Single hit DataFrame for XCZU28DR ( ADC resolution = 12bit {SingedData[15:4], ZeroPadding[3:0]}; Full scale range = 1V pk-pk  )

![dataframe_format](/figs/dataframe_format.png)

* FRAME_INFO [3:0] = {TRIGGER_STATE[1:0], FRAME_BEGIN[0:0], FRAME_CONTINUE[0:0]}
    * TRIGGER_STATE: 2'b11->Running, 2'b10->Run stop, 2'b01-> Run start
    * FRAME_BEGIN: 1->first frame , 0->not 1st frame
      * all of single frame's FRAME_BEGIN bit is 1
    * FRAME_CONTINUE: 0->single frame , 1->next frame exists
    * GAIN_TYPE is removed

* FRAME_LENGTH [11:0]
    * number of lines (excluding headers and footer) included in a data frame.
      Then, a frame size = (FRAME_LENGTH+3)*64bit

* Sign Extention [3:0] Signed Data [11:0]
    * extend sign part of RF-ADC's 12bit value to 16bit.
      - e.g. -128 (Decimal) = 0xF80 (signed int 12bit) = 0xFF80 (signed int 16bit)

* When H-gain is saturated
    * average of 2 H-gain samples and L-gain sample is assigned
      - average of 2 H-gain samples is roughly equal to 500Msps data
    * COMBINED_ID(0xCC00) is assigned on the top bits of line

* Charge sum is only sum of H-gain adc value 

# Example
## Header
For example, the first line of header configurated like below (in decimal)
```
header_id=aa, ch_id=256, frame_length=31, frame_info=1, trigger_type=0, timestampe[lower 24bit]=74565
```
will be in big-endian
```
b'\xaa\x10\x00\x1f\x10\x01\x23\x45'
```
and in little-endian (**64bit word unit**)
```
b'\x45\x23\x01\x10\x1f\x00\x10\xaa'
```
and in little-endian (**32bit word unit**)
```
b'\x1f\x00\x10\xaa\x45\x23\x01\x10'
```
    
Last Update: 2020/09/16

Single hit DataFrame for XCZU28DR ( ADC resolution = 12bit {SingedData[15:4], ZeroPadding[3:0]}; Full scale range = 1V pk-pk  )

| HEADER_ID[7:0](0xAA) |                   | CH_ID[11:0]      |  |                     | Frame Length[11:0] |                  |  | FRAME_INFO[3:0]      | TRIGGER_TYPE[3:0] | TIME_STAMP[23:0] |  |                     |                   |                      |  |
|----------------------|-------------------|------------------|--|---------------------|--------------------|------------------|--|----------------------|-------------------|------------------|--|---------------------|-------------------|----------------------|--|
| ZERO_PADING[7:0]     |                   | CHARGE_SUM[23:0] |  |                     |                    |                  |  | TRIGGER_CONFIG[31:0] |                   |                  |  |                     |                   |                      |  |
| Sign Extension[3:0]  | Signed Data[11:0] |                  |  | Sign Extension[3:0] | Signed Data[11:0]  |                  |  | Sign Extension[3:0]  | Signed Data[11:0] |                  |  | Sign Extension[3:0] | Signed Data[11:0] |                      |  |
| Sign Extension[3:0]  | Signed Data[11:0] |                  |  | Sign Extension[3:0] | Signed Data[11:0]  |                  |  | Sign Extension[3:0]  | Signed Data[11:0] |                  |  | Sign Extension[3:0] | Signed Data[11:0] |                      |  |
| …………………………………………     |                   |                  |  |                     |                    |                  |  |                      |                   |                  |  |                     |                   |                      |  |
| Sign Extension[3:0]  | Signed Data[11:0] |                  |  | Sign Extension[3:0] | Signed Data[11:0]  |                  |  | Sign Extension[3:0]  | Signed Data[11:0] |                  |  | Sign Extension[3:0] | Signed Data[11:0] |                      |  |
| TIME_STAMP[47:24]    |                   |                  |  |                     |                    | OBJECT_ID[31:24] |  | OBJECT_ID[23:0]      |                   |                  |  |                     |                   | FOOTER_ID[7:0](0x55) |
* FRAME_INFO [3:0] = {TRIGGER_STATE[1:0],  FRAME_CONTINUE[0:0], GAIN_TYPE[0:0]}
    * TRIGGER_STATE: 2'b11->Running, 2'b10->Run stop, 2'b01-> Run start
    * FRAME_CONTINUE: 0->single frame , 1->next frame exists
    * GAIN_TYPE: 0->L-gain 1->H-gain(p-gain)
    
Last Update: 2020/06/09

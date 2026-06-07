{
  "version": "1.2",
  "package": {
    "name": "",
    "version": "",
    "description": "",
    "author": "",
    "image": ""
  },
  "design": {
    "board": "ColorLight-5A-75B-V8",
    "graph": {
      "blocks": [
        {
          "id": "106598e6-fc9d-41bd-942a-ba53eec67d84",
          "type": "basic.output",
          "data": {
            "name": "",
            "virtual": false,
            "pins": [
              {
                "index": "0",
                "name": "J1_B0",
                "value": "E4"
              }
            ]
          },
          "position": {
            "x": 1160,
            "y": 72
          }
        },
        {
          "id": "920bf469-a4e5-4c77-866e-50d129a6c22c",
          "type": "basic.output",
          "data": {
            "name": "ain1",
            "virtual": false,
            "pins": [
              {
                "index": "0",
                "name": "J1_R1",
                "value": "D3"
              }
            ]
          },
          "position": {
            "x": 1536,
            "y": 208
          }
        },
        {
          "id": "48cbf24d-423d-4add-ad7c-c6dcbdb8f30b",
          "type": "basic.output",
          "data": {
            "name": "ain2",
            "virtual": false,
            "pins": [
              {
                "index": "0",
                "name": "J1_B1",
                "value": "E3"
              }
            ]
          },
          "position": {
            "x": 1536,
            "y": 352
          }
        },
        {
          "id": "107a6cb9-d7a7-4471-b3d2-5cbbef5d83d6",
          "type": "basic.input",
          "data": {
            "name": "",
            "virtual": false,
            "pins": [
              {
                "index": "0",
                "name": "CLK",
                "value": "P6"
              }
            ],
            "clock": false
          },
          "position": {
            "x": 408,
            "y": 424
          }
        },
        {
          "id": "ad72ac89-30ab-4356-970e-7997d23ac01d",
          "type": "basic.output",
          "data": {
            "name": "bin1",
            "virtual": false,
            "pins": [
              {
                "index": "0",
                "name": "J1_R0",
                "value": "C4"
              }
            ]
          },
          "position": {
            "x": 1536,
            "y": 488
          }
        },
        {
          "id": "a93bd42b-6d97-4514-8f21-4db9b8afd6c1",
          "type": "basic.input",
          "data": {
            "name": "button",
            "virtual": false,
            "pins": [
              {
                "index": "0",
                "name": "Button",
                "value": "R7"
              }
            ],
            "clock": false
          },
          "position": {
            "x": 408,
            "y": 528
          }
        },
        {
          "id": "fc827e00-295a-494a-8a8a-584aa88e2f62",
          "type": "basic.output",
          "data": {
            "name": "bin2",
            "virtual": false,
            "pins": [
              {
                "index": "0",
                "name": "J1_G0",
                "value": "D4"
              }
            ]
          },
          "position": {
            "x": 1536,
            "y": 624
          }
        },
        {
          "id": "99af293b-0548-4029-aeb6-a632cb955cfa",
          "type": "febcfed8636b8ee9a98750b96ed9e53a165dd4a8",
          "position": {
            "x": 944,
            "y": 72
          },
          "size": {
            "width": 96,
            "height": 64
          }
        },
        {
          "id": "55ada744-7732-40bb-8e98-25eee9b07653",
          "type": "basic.code",
          "data": {
            "ports": {
              "in": [
                {
                  "name": "clk"
                },
                {
                  "name": "en"
                }
              ],
              "out": [
                {
                  "name": "ain1"
                },
                {
                  "name": "ain2"
                },
                {
                  "name": "bin1"
                },
                {
                  "name": "bin2"
                }
              ]
            },
            "params": [],
            "code": "///////////////////////////////////////////////////////////////////////////////\n// Stepper Motor Controller for Colorlight 5A-75B\n// No inputs required - runs automatically on power-up\n// Outputs: ain1, ain2, bin1, bin2\n// Clock: 25 MHz (5A-75B typical)\n///////////////////////////////////////////////////////////////////////////////\n\n\n    // Speed control - adjust this value to change motor speed\n    // Formula: CLKS_PER_STEP = CLK_FREQ / (RPM * STEPS_PER_REV / 60)\n    // For 25 MHz clock, 60 RPM, 200 steps/rev: 25,000,000 / 200 = 125,000\n    localparam CLKS_PER_STEP = 125_000;  // ~60 RPM\n    reg a1 , a2 , b1 ,b2 ;\n    // Timing counter\n    reg [23:0] speed_counter;\n    \n    // Step sequence state (half-step mode for smooth operation)\n    reg [2:0] state;\n    \n    // State definitions\n    localparam S0 = 3'b000;   // A+, B+\n    localparam S1 = 3'b001;   // A+, off\n    localparam S2 = 3'b010;   // A-, B+\n    localparam S3 = 3'b011;   // off, B+\n    localparam S4 = 3'b100;   // A-, B-\n    localparam S5 = 3'b101;   // A-, off\n    localparam S6 = 3'b110;   // A+, B-\n    localparam S7 = 3'b111;   // off, B-\n    \n    // Clock divider and state machine\n    always @(posedge clk) begin\n        if (speed_counter >= CLKS_PER_STEP - 1) begin\n            speed_counter <= 0;\n            // Advance to next state\n            if (state == S7)\n                state <= S0;\n            else\n                state <= state + 1;\n        end else begin\n            speed_counter <= speed_counter + 1;\n        end\n    end\n    \n    // Output decoder - generates the four control signals\n    always @(*) begin\n        if (en != 0) begin\n        case (state)\n            S0: begin  // A+, B+\n                a1 = 1'b1; a2 = 1'b0;\n                b1 = 1'b1; b2 = 1'b0;\n            end\n            S1: begin  // A+, off\n                a1 = 1'b1; a2 = 1'b0;\n                b1 = 1'b0;b2 = 1'b0;\n            end\n            S2: begin  // A-, B+\n                a1 = 1'b0;a2 = 1'b1;\n                b1 = 1'b1;b2 = 1'b0;\n            end\n            S3: begin  // off, B+\n                a1 = 1'b0;a2 = 1'b0;\n                b1 = 1'b1;b2 = 1'b0;\n            end\n            S4: begin  // A-, B-\n                a1 = 1'b0; a2 = 1'b1;\n                b1 = 1'b0; b2 = 1'b1;\n            end\n            S5: begin  // A-, off\n                a1 = 1'b0; a2 = 1'b1;\n                b1 = 1'b0; b2 = 1'b0;\n            end\n            S6: begin  // A+, B-\n                a1 = 1'b1; a2 = 1'b0;\n                b1 = 1'b0; b2 = 1'b1;\n            end\n            S7: begin  // off, B-\n                a1 = 1'b0; a2 = 1'b0;\n                b1 = 1'b0; b2 = 1'b1;\n            end\n            default: begin\n                a1 = 1'b0; a2 = 1'b0;\n                b1 = 1'b0; b2 = 1'b0;\n            end\n        endcase\n        end\n    end\n    assign ain1 = a1;\n    assign ain2 = a2;\n    assign bin1 = b1;\n    assign bin2 = b2;\n"
          },
          "position": {
            "x": 632,
            "y": 176
          },
          "size": {
            "width": 792,
            "height": 544
          }
        }
      ],
      "wires": [
        {
          "source": {
            "block": "55ada744-7732-40bb-8e98-25eee9b07653",
            "port": "ain1"
          },
          "target": {
            "block": "920bf469-a4e5-4c77-866e-50d129a6c22c",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "55ada744-7732-40bb-8e98-25eee9b07653",
            "port": "ain2"
          },
          "target": {
            "block": "48cbf24d-423d-4add-ad7c-c6dcbdb8f30b",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "55ada744-7732-40bb-8e98-25eee9b07653",
            "port": "bin1"
          },
          "target": {
            "block": "ad72ac89-30ab-4356-970e-7997d23ac01d",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "55ada744-7732-40bb-8e98-25eee9b07653",
            "port": "bin2"
          },
          "target": {
            "block": "fc827e00-295a-494a-8a8a-584aa88e2f62",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "107a6cb9-d7a7-4471-b3d2-5cbbef5d83d6",
            "port": "out"
          },
          "target": {
            "block": "55ada744-7732-40bb-8e98-25eee9b07653",
            "port": "clk"
          }
        },
        {
          "source": {
            "block": "99af293b-0548-4029-aeb6-a632cb955cfa",
            "port": "3d584b0a-29eb-47af-8c43-c0822282ef05"
          },
          "target": {
            "block": "106598e6-fc9d-41bd-942a-ba53eec67d84",
            "port": "in"
          }
        },
        {
          "source": {
            "block": "a93bd42b-6d97-4514-8f21-4db9b8afd6c1",
            "port": "out"
          },
          "target": {
            "block": "55ada744-7732-40bb-8e98-25eee9b07653",
            "port": "en"
          }
        }
      ]
    }
  },
  "dependencies": {
    "febcfed8636b8ee9a98750b96ed9e53a165dd4a8": {
      "package": {
        "name": "bit-1",
        "version": "0.2",
        "description": "Constant bit 1",
        "author": "Jesus Arroyo",
        "image": "%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20width=%2289.79%22%20height=%22185.093%22%20viewBox=%220%200%2084.179064%20173.52585%22%3E%3Cpath%20d=%22M7.702%2032.42L49.972%200l34.207%207.725-27.333%20116.736-26.607-6.01L51.26%2025.273%2020.023%2044.2z%22%20fill=%22green%22%20fill-rule=%22evenodd%22/%3E%3Cpath%20d=%22M46.13%20117.28l21.355%2028.258-17.91%2021.368%206.198%205.513m-14.033-54.45l-12.4%2028.26-28.242%205.512%202.067%208.959%22%20fill=%22none%22%20stroke=%22green%22%20stroke-width=%222.196%22%20stroke-linecap=%22round%22%20stroke-linejoin=%22round%22/%3E%3C/svg%3E"
      },
      "design": {
        "graph": {
          "blocks": [
            {
              "id": "3d584b0a-29eb-47af-8c43-c0822282ef05",
              "type": "basic.output",
              "data": {
                "name": ""
              },
              "position": {
                "x": 456,
                "y": 120
              }
            },
            {
              "id": "61331ec5-2c56-4cdd-b607-e63b1502fa65",
              "type": "basic.code",
              "data": {
                "code": "//-- Constant bit-1\nassign q = 1'b1;\n\n",
                "params": [],
                "ports": {
                  "in": [],
                  "out": [
                    {
                      "name": "q"
                    }
                  ]
                }
              },
              "position": {
                "x": 168,
                "y": 112
              },
              "size": {
                "width": 248,
                "height": 80
              }
            }
          ],
          "wires": [
            {
              "source": {
                "block": "61331ec5-2c56-4cdd-b607-e63b1502fa65",
                "port": "q"
              },
              "target": {
                "block": "3d584b0a-29eb-47af-8c43-c0822282ef05",
                "port": "in"
              }
            }
          ]
        }
      }
    }
  }
}
module  add4( sum, co, a, b, ci);

  input   [3:0] a, b;
  input   ci;
  output  [3:0] sum;
  output  co;

  assign {co, sum} = a + b + ci;  
endmodule

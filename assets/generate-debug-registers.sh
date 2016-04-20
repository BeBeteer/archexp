#!/bin/bash
for i in `seq 0 31`; do
  echo "wire [31:0] cpu_id_register${i} = cpu_id_registers[$((${i} + 1)) * 32 - 1 : ${i} * 32];"
done
echo
for i in `seq 0 31`; do
  echo "cpu_id_register${i}"
done

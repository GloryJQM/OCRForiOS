rem ִ�и�������ǰ��ҪĿ¼�´���font_properties�ļ�  

echo Run Tesseract for Training..  
tesseract.exe sll.normal.exp0.tif sll.normal.exp0 nobatch box.train  
  
echo Compute the Character Set..  
unicharset_extractor.exe sll.normal.exp0.box  
mftraining -F font_properties -U unicharset -O sll.unicharset sll.normal.exp0.tr  
  
echo Clustering..  
cntraining.exe sll.normal.exp0.tr  
  
echo Rename Files..  
rename normproto sll.normproto  
rename inttemp sll.inttemp  
rename pffmtable sll.pffmtable  
rename shapetable sll.shapetable   
  
echo Create Tessdata..  
combine_tessdata.exe sll.

echo. & pause
for /r "AI\" %%i in (*.ai) do (
copy /y %%i   PDF\%%~ni.pdf
)
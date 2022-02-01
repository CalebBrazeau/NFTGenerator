> # Processing NFTGenerator
>
>  Program that layers images to create NFT's and their meta data

> ## Usage:
>
> This program allows users to load their assets into folders and generate a specified number of NFT's and their meta data.
> Each layer should be in its own folder ordered for how you want them to stack. In the following example images will be layered starting with the background, the character, then glasses: 
>> ### Example File Structure:
>> - assets
>>   - background
>>     - img #100.png
>>     - img #100.png
>>   - character
>>     - img #100.png
>>     - img #100.png
>>   - glasses
>>     - img #100.png
>>     - img #100.png  
>>
>> A way to sort these if your file names are not sorted correctly is by doing something like this:  
>>
>> - assets
>>   - a - background
>>     - img #100.png
>>     - img #100.png
>>   - b - character
>>     - img #100.png
>>     - img #100.png
>>   - c - glasses
>>     - img #100.png
>>     - img #100.png  
>>
>> Each asset should include a rarity number (e.x. #100), files without a rarity number will default to 100.
>>
>
> ### Instructions:
> 1. Load assets into '/assets/' folder. The folders must be in order for how you want them to stack from bottom to top. For example, if the 'background' folder is bellow the 'faces' folder, the background will be layerd on top of the 'faces' asset.
> 2. ***IMPORTANT*** Change the following variables:
>>   1. &lt;20&gt;: **NFTName**: Set to the name of your NFT/NFT Collection.
>>   1. &lt;22&gt;: **NFTDescription**: Set to the description of your NFT Collection. (e.g. An exclusive collection of unique Geode NFT's grown in the Solana blockchain).
>>   1. &lt;24&gt;: **collectionName**: Set to the name of your NFT Collection.
>>   1. &lt;26&gt;: **NFTUri**: Set to the URI of where the files are stored.
>>   1. &lt;28&gt;: **sellerRoyalties**: Set to the amount royalties you want to recieve from secondary sales. The number represents a percentage so it should be 100x the amount of royalties you want to receive. (e.g. 1000 would be 10%)
>>   1. &lt;31&gt;: **creatorAddress**: This array contains the address to distribute currency to during sales. Either change the current address to your address or add more address. To add more addresses, add a comma after the end quote, then add the new address in quotations. (e.g. {"&lt;address&gt;"} would turn into {"&lt;address&gt;", "&lt;address&gt;"})
>>   1. &lt;34&gt;: **creatorShare**: This array contains the share percentage to give to each creator address. Either change the current address to your address or add more address. If you add more addresses you must update this to include either a 0 or a split between the two addresses. To add new shares, simply add a comma at the end of the first value then add the new value. (e.g. {&lt;share&gt;} would turn into {&lt;share&gt;, &lt;share&gt;}) 
***NOTE:*** This must total 100, or the program will throw an error. There also must be an equal number of addresses to shares or the program will throw an error.
> 3. ***\*OPTIONAL:\****
>    1. If you want random background colors set, **doRandomBgColor** on line 14, to '*true*'.
>    1. &lt;16&gt;: **bgMin**: Set minimum RGB value for background colors.
>    1. &lt;17&gt;: **bgMax**: Set maximum RGB value for background colors.
> ## Running the Program
> Before running the program, you have to decied how many NFT's you want to generate. Collections can range from 1 NFT to probably an infinite number, but that would take away from any thoughts of rarity. Generally collections stay below the 10,000 image mark, but it is all up to you. To set the number of NFTs's to be generated simply change the number inside the parenthesese on line 35 to however many NFT's you would like to generate. (e.g. gen(420); Would generate 420 NFT's and 420 json files).
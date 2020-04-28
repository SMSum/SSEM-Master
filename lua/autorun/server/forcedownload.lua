function addContentFolder( path )local files, folders = file.Find( path .. "/*", "GAME" )
        for k, v inpairs( files ) do
                resource.AddFile( path .. "/" .. v )
        end

        for k, v inpairs( folders ) do
                addContent( path .. "/" .. v )
        end
    end
addContentFolder("models/sem" )
addContentFolder("materials/models" )


setlocal tabstop=2 softtabstop=2 shiftwidth=2
setlocal textwidth=80
setlocal colorcolumn=121
setlocal formatprg=stylish-haskell

" Change "a (function application)" to "a $ function application"
nnoremap <buffer> <Leader>$ :normal dsbi$<Space><CR>

let g:hs_exts = ['AllowAmbiguousTypes', 'AlternativeLayoutRule', 'AlternativeLayoutRuleTransitional', 'ApplicativeDo', 'Arrows', 'BangPatterns', 'BinaryLiterals', 'BlockArguments', 'CApiFFI', 'CPP', 'CUSKs', 'ConstrainedClassMethods', 'ConstraintKinds', 'DataKinds', 'DefaultSignatures', 'DeriveAnyClass', 'DeriveDataTypeable', 'DeriveFoldable', 'DeriveFunctor', 'DeriveGeneric', 'DeriveLift', 'DeriveTraversable', 'DerivingStrategies', 'DerivingVia', 'DisambiguateRecordFields', 'DoAndIfThenElse', 'DuplicateRecordFields', 'EmptyCase', 'EmptyDataDecls', 'EmptyDataDeriving', 'ExistentialQuantification', 'ExplicitForAll', 'ExplicitNamespaces', 'ExtendedDefaultRules', 'FlexibleContexts', 'FlexibleInstances', 'ForeignFunctionInterface', 'FunctionalDependencies', 'GADTSyntax', 'GADTs', 'GHCForeignImportPrim', 'GeneralisedNewtypeDeriving', 'GeneralizedNewtypeDeriving', 'Haskell2010', 'Haskell98', 'HexFloatLiterals', 'ImplicitParams', 'ImplicitPrelude', 'ImportQualifiedPost', 'ImpredicativeTypes', 'IncoherentInstances', 'InstanceSigs', 'InterruptibleFFI', 'JavaScriptFFI', 'KindSignatures', 'LambdaCase', 'LexicalNegation', 'LiberalTypeSynonyms', 'LinearTypes', 'MagicHash', 'MonadComprehensions', 'MonoLocalBinds', 'MonomorphismRestriction', 'MultiParamTypeClasses', 'MultiWayIf', 'NPlusKPatterns', 'NamedFieldPuns', 'NamedWildCards', 'NegativeLiterals', 'NoAllowAmbiguousTypes', 'NoAlternativeLayoutRule', 'NoAlternativeLayoutRuleTransitional', 'NoApplicativeDo', 'NoArrows', 'NoBangPatterns', 'NoBinaryLiterals', 'NoBlockArguments', 'NoCApiFFI', 'NoCPP', 'NoCUSKs', 'NoConstrainedClassMethods', 'NoConstraintKinds', 'NoDataKinds', 'NoDefaultSignatures', 'NoDeriveAnyClass', 'NoDeriveDataTypeable', 'NoDeriveFoldable', 'NoDeriveFunctor', 'NoDeriveGeneric', 'NoDeriveLift', 'NoDeriveTraversable', 'NoDerivingStrategies', 'NoDerivingVia', 'NoDisambiguateRecordFields', 'NoDoAndIfThenElse', 'NoDuplicateRecordFields', 'NoEmptyCase', 'NoEmptyDataDecls', 'NoEmptyDataDeriving', 'NoExistentialQuantification', 'NoExplicitForAll', 'NoExplicitNamespaces', 'NoExtendedDefaultRules', 'NoFlexibleContexts', 'NoFlexibleInstances', 'NoForeignFunctionInterface', 'NoFunctionalDependencies', 'NoGADTSyntax', 'NoGADTs', 'NoGHCForeignImportPrim', 'NoGeneralisedNewtypeDeriving', 'NoGeneralizedNewtypeDeriving', 'NoHexFloatLiterals', 'NoImplicitParams', 'NoImplicitPrelude', 'NoImportQualifiedPost', 'NoImpredicativeTypes', 'NoIncoherentInstances', 'NoInstanceSigs', 'NoInterruptibleFFI', 'NoJavaScriptFFI', 'NoKindSignatures', 'NoLambdaCase', 'NoLexicalNegation', 'NoLiberalTypeSynonyms', 'NoLinearTypes', 'NoMagicHash', 'NoMonadComprehensions', 'NoMonoLocalBinds', 'NoMonomorphismRestriction', 'NoMultiParamTypeClasses', 'NoMultiWayIf', 'NoNPlusKPatterns', 'NoNamedFieldPuns', 'NoNamedWildCards', 'NoNegativeLiterals', 'NoNondecreasingIndentation', 'NoNumDecimals', 'NoNumericUnderscores', 'NoOverloadedLabels', 'NoOverloadedLists', 'NoOverloadedStrings', 'NoPackageImports', 'NoParallelArrays', 'NoParallelListComp', 'NoPartialTypeSignatures', 'NoPatternGuards', 'NoPatternSynonyms', 'NoPolyKinds', 'NoPolymorphicComponents', 'NoPostfixOperators', 'NoQualifiedDo', 'NoQuantifiedConstraints', 'NoQuasiQuotes', 'NoRank2Types', 'NoRankNTypes', 'NoRebindableSyntax', 'NoRecordWildCards', 'NoRecursiveDo', 'NoRelaxedLayout', 'NoRoleAnnotations', 'NoScopedTypeVariables', 'NoStandaloneDeriving', 'NoStandaloneKindSignatures', 'NoStarIsType', 'NoStaticPointers', 'NoStrict', 'NoStrictData', 'NoTemplateHaskell', 'NoTemplateHaskellQuotes', 'NoTraditionalRecordSyntax', 'NoTransformListComp', 'NoTupleSections', 'NoTypeApplications', 'NoTypeFamilies', 'NoTypeFamilyDependencies', 'NoTypeInType', 'NoTypeOperators', 'NoTypeSynonymInstances', 'NoUnboxedSums', 'NoUnboxedTuples', 'NoUndecidableInstances', 'NoUndecidableSuperClasses', 'NoUnicodeSyntax', 'NoUnliftedFFITypes', 'NoUnliftedNewtypes', 'NoViewPatterns', 'NondecreasingIndentation', 'NumDecimals', 'NumericUnderscores', 'OverloadedLabels', 'OverloadedLists', 'OverloadedStrings', 'PackageImports', 'ParallelArrays', 'ParallelListComp', 'PartialTypeSignatures', 'PatternGuards', 'PatternSynonyms', 'PolyKinds', 'PolymorphicComponents', 'PostfixOperators', 'QualifiedDo', 'QuantifiedConstraints', 'QuasiQuotes', 'Rank2Types', 'RankNTypes', 'RebindableSyntax', 'RecordWildCards', 'RecursiveDo', 'RelaxedLayout', 'RoleAnnotations', 'Safe', 'ScopedTypeVariables', 'StandaloneDeriving', 'StandaloneKindSignatures', 'StarIsType', 'StaticPointers', 'Strict', 'StrictData', 'TemplateHaskell', 'TemplateHaskellQuotes', 'TraditionalRecordSyntax', 'TransformListComp', 'Trustworthy', 'TupleSections', 'TypeApplications', 'TypeFamilies', 'TypeFamilyDependencies', 'TypeInType', 'TypeOperators', 'TypeSynonymInstances', 'UnboxedSums', 'UnboxedTuples', 'UndecidableInstances', 'UndecidableSuperClasses', 'UnicodeSyntax', 'UnliftedFFITypes', 'UnliftedNewtypes', 'Unsafe', 'ViewPatterns']

function! s:CompleteHsLanguageExts(A, L, P) abort
    let exts = g:hs_exts[:]
    call filter(exts, 'v:val =~? a:A')
    return exts
endfunction

function! s:InsertExt(ext) abort
    if !empty(trim(a:ext))
        let ln = 1
        let lastline = line('$')
        " Skip shebangs
        while ln <= lastline && getline(ln) =~# '#!'
            let ln += 1
        endwhile
        call append(ln - 1, '{-# language ' . a:ext . ' #-}')
        " Append blank line if module comes right after language extension
        if getline(ln + 1) =~# 'module'
            call append(ln, '')
        endif
    endif
endfunction

" Prompt for and insert a language extension at the top of the current buffer
command! -nargs=1 -complete=customlist,<SID>CompleteHsLanguageExts Ext call <SID>InsertExt(<q-args>)

command! -range SortImports <line1>,<line2>sort /import\s\+\(qualified\)\=\s*/


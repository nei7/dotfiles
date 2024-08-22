export type Song = {
    serviceName: string,
    name: string,
    title: string,
    status: string,
    artist: string,
    album: string,
    length: number,
    lengthStr: string,
    artwork?: string,
    canGoNext: boolean,
    canGoPrevious: boolean,
    canPlay: boolean,
    canPause: boolean,
}

export type Position = {
    position: number,
    positionStr: string
}
